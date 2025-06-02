import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cible_militaire/Services/authentificationService.dart';
import 'package:cible_militaire/Services/firebaseService.dart';
import 'package:cible_militaire/Services/user_session.dart';
import 'package:cible_militaire/model/shot.dart';
import 'package:cible_militaire/view/pages/trainingStats.dart';
import 'package:cible_militaire/view/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TrainingSessionPage extends StatefulWidget {
  final String selectedMode;
  final Map<String, dynamic> selectedTarget;

  const TrainingSessionPage({
    super.key,
    required this.selectedMode,
    required this.selectedTarget,
  });

  @override
  State<TrainingSessionPage> createState() => _TrainingSessionPageState();
}

class _TrainingSessionPageState extends State<TrainingSessionPage> with TickerProviderStateMixin {
  // Timer variables
  Timer? _timer;
  Timer? _countdownTimer;
  dynamic _timeRemaining = 0;
  bool _isCountingDown = false;
  bool _isSessionActive = false;
  bool _isSessionComplete = false;
  bool _isPaused = false;
  Timer? _blinkTimer;
  bool _isBlinking = false;

  // Target section colors
  Color section1Color = Colors.black; // Tête
  Color section2Color = Colors.black; // Extrémité
  Color section3Color = Colors.black; // Ventre
  
  // Countdown variables
  String _countdownText = "AUSSITÔT PRÊT";
  bool _showCountdownText = false;
  Timer? _countdownTextTimer;
  Color _countdownColor = Colors.red;
  double _countdownScale = 0.5;
  AnimationController? _countdownController;
  
  // Chronometer variables
  int _elapsedSeconds = 0;
  String _formattedTime = "00:00";
  
  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Shot tracking
  List<Shot> _shots = [];
  int _currentSeries = 1;
  dynamic _maxSeries = 1;
  dynamic _maxShots = 0;
  
  // Session stats
  double _totalScore = 0;
  double _accuracy = 0;
  String _averageScore = "0.0";
  
  // Section stats
  int _headShots = 0;
  int _torsoShots = 0;
  int _extremityShots = 0;

  late FirebaseService _firebaseService;


  @override
  void initState() {
    super.initState();
    _initializeSessionParameters();
    _updateCurrentTime();
     

  // Initialiser Firebase à l'état de base
  _firebaseService = FirebaseService();
  _firebaseService.initializeData();

    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _countdownTextTimer?.cancel();
    _timer?.cancel();
    _countdownTimer?.cancel();
    _audioPlayer.dispose();
    _countdownController?.dispose(); 
    super.dispose();
  }

  void _initializeSessionParameters() {
    switch (widget.selectedMode) {
      case "Entraînement libre":
        _timeRemaining = 'illimité';
        _maxShots = 'illimité';
        _maxSeries = 1;
        _formattedTime = "00:00";
        break;
      case "Entraînement dirigé":
        _timeRemaining = 60;
        _maxShots = 10;
        _maxSeries = 2;
        break;
      case "Entraînement compétition":
        _timeRemaining = 30;
        _maxShots = 10;
        _maxSeries = 1;
        break;
      default:
        _timeRemaining = 60;
        _maxShots = 10;
        _maxSeries = 1;
    }
    _updateFormattedTime();
  }

  void _updateCurrentTime() {
    setState(() {
      final now = DateTime.now();
    });
    Timer(const Duration(seconds: 1), _updateCurrentTime);
  }

  void _startSessionTimer(){
    _timer?.cancel();
    
    if (widget.selectedMode == "Entraînement libre") {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          _updateFormattedTime();
        });
      });
    } else if (_timeRemaining is int) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
            _updateFormattedTime();
            if (_timeRemaining == 0) _endCurrentSeries();
          }
        });
      });
    }
  }
  
  void _updateFormattedTime() {
    if (widget.selectedMode == "Entraînement libre") {
      int minutes = _elapsedSeconds ~/ 60;
      int seconds = _elapsedSeconds % 60;
      _formattedTime = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else if (_timeRemaining is int) {
      int minutes = _timeRemaining ~/ 60;
      int seconds = _timeRemaining % 60;
      _formattedTime = "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      _formattedTime = "∞:∞";
    }
  }

  void _startInitialCountdown() {
    if (_isCountingDown || _isSessionActive) return;

_firebaseService.initializeData;
    setState(() {
      _isCountingDown = true;
      _showCountdownText = true;
      _countdownText = "AUSSITÔT PRÊT";
      _countdownColor = Colors.orange;
      _countdownScale = 0.5;
    });

    _playSound('countdown_start.mp3');
    _countdownController?.forward();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _countdownScale = 1.1;
      });
    }).then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _countdownScale = 1.0;
        });
      });
    });

    _countdownTextTimer = Timer(const Duration(seconds: 2), () {
      _playSound('countdown_beep.mp3');
      
      setState(() {
        _countdownText = "COMMENCEZ LE FEU";
        _countdownColor = Colors.red;
        _countdownScale = 1.1;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _countdownScale = 1.0;
        });
      });

      _countdownTextTimer = Timer(const Duration(seconds: 2), () {
        _playSound('session_start.mp3');
        
        setState(() {
          _countdownScale = 1.2;
        });
        
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _showCountdownText = false;
            _isCountingDown = false;
            _startSession();
          });
        });
      });
    });
  }


  Future<void> _playSound(String soundFile) async {
    try {
      await _audioPlayer.play(AssetSource('sons/$soundFile'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _startSession() {
    if (_isSessionActive) return;

    setState(() {
      _isSessionActive = true;
      _isPaused = false;
      _isSessionComplete = false;
      _shots = [];
      _totalScore = 0;
      _accuracy = 0;
      _averageScore = "0.0";
      _currentSeries = 1;
      _elapsedSeconds = 0;
      _headShots = 0;
      _torsoShots = 0;
      _extremityShots = 0;
      _initializeSessionParameters();
    });
     // Écoute des changements pour déclencher les blink
  _firebaseService.listenToSectionChanges(
    onHead: _blinkSection1,
    onTorso: _blinkSection3,
    onExtremity: _blinkSection2,
  );

    _startSessionTimer();
  }

  void _endCurrentSeries() {
    if (_currentSeries < _maxSeries) {
      setState(() {
        _currentSeries++;
        if (widget.selectedMode == "Entraînement dirigé") {
          _timeRemaining = 60;
        } else if (widget.selectedMode == "Entraînement compétition") {
          _timeRemaining = 30;
        }
        _updateFormattedTime();
      });
      _startSessionTimer();
    } else {
      _completeSession();
    }
  }

  void _recordHit(String section) {
    if (!_isSessionActive || _isSessionComplete) return;
    
    if (_maxShots is int && _shots.where((shot) => shot.series == _currentSeries).length >= _maxShots) {
      _endCurrentSeries();
      return;
    }
    



    setState(() {
      _shots.add(Shot(
        section: section,
        series: _currentSeries,
        timestamp: DateTime.now(),
      ));
      _totalScore += _shots.last.score;
      _updateSectionStats();
      _calculateAccuracy();
      _calculateAverageScore();
    });
    
    if (_maxShots is int && _shots.where((shot) => shot.series == _currentSeries).length >= _maxShots) {
      _endCurrentSeries();
    }
  }

  void _updateSectionStats() {
    _headShots = _shots.where((shot) => shot.section == "head").length;
    _torsoShots = _shots.where((shot) => shot.section == "torso").length;
    _extremityShots = _shots.where((shot) => shot.section == "extremity").length;
  }

  void _calculateAccuracy() {
    if (_shots.isEmpty) {
      _accuracy = 0;
      return;
    }
    final goodShots = _headShots + _torsoShots;
    _accuracy = (goodShots / _shots.length) * 100;
  }

  void _calculateAverageScore() {
    if (_shots.isEmpty) {
      _averageScore = "0.0";
      return;
    }
    _averageScore = (_totalScore / _shots.length).toStringAsFixed(1);
  }

void _completeSession() async {
  setState(() {
    _isSessionComplete = true;
    _isSessionActive = false;
  });
  _timer?.cancel();
  _countdownTimer?.cancel();
  _playSound('session_end.mp3');
  
  // Récupérer le joueur connecté (vous devrez peut-être passer cette info à la page)
  final userSession = Provider.of<UserSession>(context, listen: false);
  final currentPlayer = userSession.currentUser;
  currentPlayer!.extremite = _extremityShots;
  currentPlayer.parties ++;
  currentPlayer.points = (currentPlayer.points + _totalScore) as int ;
  currentPlayer.tete = _headShots;
  currentPlayer.ventre = _torsoShots;
    print("current player complet: $currentPlayer"  );
    // Mettre à jour les stats dans le JSON


final success = await AuthService.updatePlayerStats(
  currentPlayer!,
  _shots,
);

    
    if (success) {
      print("Statistiques mises à jour avec succès");
      // Dans _completeSession, après la mise à jour réussie
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Statistiques enregistrées!'))
  );
}
  
  
  _firebaseService.initializeData();
}
}

  void _pauseSession() {
    if (!_isSessionActive || _isPaused) return;
    setState(() {
      _isPaused = true;
      _timer?.cancel();
    });
    _playSound('pause.mp3');
  }

  void _resumeSession() {
    if (!_isSessionActive || !_isPaused) return;
    setState(() {
      _isPaused = false;
      _startSessionTimer();
    });
    _playSound('resume.mp3');
  }
  
  void _resetSession() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    setState(() {
      _isPaused = false;
      _isSessionActive = false;
      _isSessionComplete = false;
      _isCountingDown = false;
      _shots = [];
      _totalScore = 0;
      _accuracy = 0;
      _averageScore = "0.0";
      _currentSeries = 1;
      _elapsedSeconds = 0;
      _headShots = 0;
      _torsoShots = 0;
      _extremityShots = 0;
      _initializeSessionParameters();
    });
    
    _firebaseService.initializeData();

    _playSound('reset.mp3');
  }

  void _blinkSection1() {
  _recordHit("head");

  if (_isBlinking) {
    _blinkTimer?.cancel();
    setState(() {
      section1Color = Colors.black;
      _isBlinking = false;
    });
    return;
  }

  setState(() {
    _isBlinking = true;
    section1Color = Colors.red;
  });
  Future.delayed(Duration(seconds: 2), () => _playSound('shot_pist.mp3'));

  _blinkTimer = Timer(const Duration(milliseconds: 500), () {

    setState(() {
      section1Color = Colors.black;
      _isBlinking = false;
    });
  });
}


  void _blinkSection2() {
  _recordHit("extremity");

  if (_isBlinking) {
    _blinkTimer?.cancel();
    setState(() {
      section2Color = Colors.black;
      _isBlinking = false;
    });
    return;
  }

  setState(() {
    _isBlinking = true;
    section2Color = const Color.fromARGB(255, 241, 244, 54);
  });
  Future.delayed(Duration(seconds: 2), () => _playSound('shot_pist.mp3'));

  _blinkTimer = Timer(const Duration(milliseconds: 500), () {

    setState(() {
      section2Color = Colors.black;
      _isBlinking = false;
    });
  });

}

void _blinkSection3() {
  _recordHit("torso");

  if (_isBlinking) {
    _blinkTimer?.cancel();
    setState(() {
      section3Color = Colors.black;
      _isBlinking = false;
    });
    return;
  }

  setState(() {
    _isBlinking = true;
    section3Color = const Color.fromARGB(255, 244, 124, 54);
  });
       
  Future.delayed(Duration(seconds: 2), () => _playSound('shot_pist.mp3'));

  _blinkTimer = Timer(const Duration(milliseconds: 500), () {
    
    setState(() {
      section3Color = Colors.black;
      _isBlinking = false;
    });

  });
}

  String _buildSvgString() {
    return '''
    <svg version="1.0" xmlns="http://www.w3.org/2000/svg"
     viewBox="0 0 369 604" preserveAspectRatio="xMidYMid meet">
    <g transform="translate(0,604) scale(0.1,-0.1)" stroke="none">
      
      <!-- Séction 1 Tète -->
      <path d="M1340 5918 c-30 -28 -90 -84 -133 -124 l-77 -73 2 -538 3 -538 710 0
      710 0 3 530 2 530 -137 132 -138 132 -445 0 -445 0 -55 -51z" fill="${_colorToHex(section1Color)}"/>
      
      <!-- Séction 2: Extremité -->
      <path d="M440 4419 c-118 -105 -250 -223 -292 -261 l-78 -70 1 -1747 0 -1746
      140 -125 c77 -69 211 -189 297 -267 l157 -142 518 -1 517 0 0 470 0 470 -164
      0 -164 0 -146 136 c-80 75 -146 142 -146 148 0 6 0 539 0 1184 l0 1174 87 82
      c49 45 111 103 139 129 l51 47 491 0 492 0 145 -132 145 -133 -1 -1185 -1
      -1185 -52 -45 c-28 -25 -86 -76 -128 -113 -42 -37 -86 -77 -99 -87 -20 -18
      -38 -20 -186 -20 l-163 0 0 -470 0 -470 514 0 515 0 238 216 c131 120 264 241
      295 271 l58 54 0 1743 0 1744 -67 58 c-38 32 -75 65 -83 73 -8 8 -106 95 -217
      193 -111 98 -205 183 -208 188 -4 6 -436 10 -1198 10 l-1193 0 -214 -191z" fill="${_colorToHex(section2Color)}"/>
      
      <!-- Séction 3: Ventre -->
      <path d="M1233 3757 l-132 -122 -1 -1176 0 -1176 37 -33 c21 -19 82 -76 136
      -127 l99 -93 480 0 479 0 140 126 139 126 0 1167 0 1167 -67 65 c-38 36 -101
      95 -142 132 l-73 67 -482 0 -481 -1 -132 -122z" fill="${_colorToHex(section3Color)}"/>
      <path d="M1730 530 l0 -470 125 0 125 0 0 470 0 470 -125 0 -125 0 0 -470z" fill="${_colorToHex(section3Color)}"/>

    </g>
    </svg>
    ''';
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  Color _getShotColor(String section) {
    switch (section) {
      case "head":
        return Colors.green;
      case "torso":
        return Colors.blue;
      case "extremity":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/4.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          Column(
            children: [
              const NavBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                      children: [
                        _buildSessionHeader(),
                        const SizedBox(height: 8),
                        Expanded(
                          child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 4, child: _buildTargetPanel()),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _buildStatsPanel()),
                                ],
                              )  
                        ),
                      ],
                    ),
                    if (_isCountingDown) _buildCountdownOverlay()
                    ]
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.sports_handball, size: 20, color: Colors.grey[800]),
              const SizedBox(width: 8),
              Text(
                widget.selectedMode,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.timer, size: 20, color: Colors.grey[800]),
          const SizedBox(width: 4),
          Text(
            widget.selectedMode == "Entraînement libre" 
                ? "Temps: illimité" 
                : "Temps: $_timeRemaining sec",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.golf_course, size: 20, color: Colors.grey[800]),
          const SizedBox(width: 4),
          Text(
            "Tirs: $_maxShots",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.repeat, size: 20, color: Colors.grey[800]),
          const SizedBox(width: 4),
          Text(
            "Séries: $_maxSeries",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: AnimatedOpacity(
            opacity: _showCountdownText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              transform: Matrix4.diagonal3Values(_countdownScale, _countdownScale, 1),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _countdownColor, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: _countdownColor.withOpacity(0.7),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                _countdownText,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: _countdownColor.withOpacity(0.9),
                      blurRadius: 15,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 500,
                height: 500,
                child: SvgPicture.string(
                  _buildSvgString(),
                  fit: BoxFit.contain,
                  key: ValueKey('$section1Color-$section2Color-$section3Color'),

                ),
              ),
            ),
          ),
         
          Container(
            height: 50,
            color: Colors.grey[300]?.withOpacity(0.5),
            child: Center(
              child: Text(
                "Total: ${_totalScore.toStringAsFixed(1)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
  Shot? lastShot = _shots.isNotEmpty ? _shots.last : null;
  
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        child: Column(
          children: [
            Text(
              _formattedTime,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
                color: widget.selectedMode != "Entraînement libre" && _timeRemaining is int && _timeRemaining <= 10 
                    ? Colors.red 
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isSessionActive) {
                      if (_isPaused) {
                        _resumeSession();
                      } else {
                        _pauseSession();
                      }
                    } else if (!_isCountingDown) {
                      _startInitialCountdown();
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (!_isSessionActive && !_isCountingDown) || _isPaused
                          ? Colors.blue.withOpacity(0.8)
                          : Colors.grey[400]?.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isSessionActive && !_isPaused ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: (_isPaused || _isSessionComplete) ? _resetSession : null,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (_isPaused || _isSessionComplete)
                          ? Colors.orange.withOpacity(0.8)
                          : Colors.grey[400]?.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.replay,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _isSessionActive ? _completeSession : null,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isSessionActive
                          ? Colors.red.withOpacity(0.8)
                          : Colors.grey[400]?.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flag,
                      color: _isSessionActive ? Colors.white : Colors.grey[700],
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300]?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Text(
              "Moyenne: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              _averageScore,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      
      Expanded(
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(4),
    ),
    child: SingleChildScrollView(            // 👈 Ajouté ici
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (lastShot != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getShotColor(lastShot.section).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _getShotColor(lastShot.section), width: 1),
                  ),
                  child: Text(
                    _getSectionName(lastShot.section),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getShotColor(lastShot.section),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Historique des tirs:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // En-tête du tableau
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Text(
                    'N°',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Section',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Score',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Tableau scrollable
          SizedBox(                     // 👈 Au lieu de Expanded
            height: 300,                // 👈 adapte la hauteur selon ton besoin
            child: _shots.isEmpty
                ? Center(
                    child: Text(
                      'Aucun tir enregistré',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _shots.length,
                    itemBuilder: (context, index) {
                      final shot = _shots[_shots.length - 1 - index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${_shots.length - index}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getShotColor(shot.section),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _getSectionName(shot.section),
                                    style: TextStyle(
                                      color: _getShotColor(shot.section),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                shot.score.toStringAsFixed(1),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  ),
),

      if (_isSessionComplete) 
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingStatsPage(
                    selectedMode: widget.selectedMode,
                    selectedTarget: widget.selectedTarget,
                    shots: _shots,
                    maxSeries: _maxSeries,
                    totalScore: _totalScore,
                    accuracy: _accuracy,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, size: 20),
                SizedBox(width: 8),
                Text('Voir les statistiques complètes'),
              ],
            ),
          ),
        ),
    ],
  );
}

// Ajouter cette méthode pour convertir les noms de section
String _getSectionName(String section) {
  switch (section) {
    case "head":
      return "Tête";
    case "torso":
      return "Ventre";
    case "extremity":
      return "Extrémité";
    default:
      return "Inconnu";
  }
}
}