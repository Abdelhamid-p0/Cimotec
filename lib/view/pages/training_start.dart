import 'dart:async';
import 'dart:math' as math;
import 'package:cible_militaire/view/models/shot.dart';
import 'package:cible_militaire/view/pages/trainingStats.dart';
import 'package:cible_militaire/view/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class _TrainingSessionPageState extends State<TrainingSessionPage> {
  // Timer variables
  Timer? _timer;
  int _timeRemaining = 0;
  bool _isSessionActive = false;
  bool _isSessionComplete = false;
  
  // Shot tracking
  List<Shot> _shots = [];
  int _currentSeries = 1;
  int _maxSeries = 1;
  int _maxShots = 0;
  
  // Session stats
  double _totalScore = 0;
  double _accuracy = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeSessionParameters();
  }

  void _startRandomShots() {
  const interval = Duration(seconds: 1); // Intervalle entre les tirs
  const maxShots = 10; // Nombre maximum de tirs à générer

  int shotCount = 0;

  _timer = Timer.periodic(interval, (timer) {
    if (!_isSessionActive || _isSessionComplete || shotCount >= maxShots) {
      timer.cancel(); // Arrête le timer si la session est terminée ou inactive
      return;
    }

    // Génère des coordonnées aléatoires dans la zone de la cible (400x400)
    final random = math.Random();
    final x = random.nextDouble() * 400; // Entre 0 et 400
    final y = random.nextDouble() * 400; // Entre 0 et 400

    // Enregistre le tir
    _recordShot(x, y);

    shotCount++;
  });
}
  
  void _initializeSessionParameters() {
    // Set parameters based on the selected mode
    switch (widget.selectedMode) {
      case "Entraînement libre":
        _timeRemaining = 0; // Unlimited time
        _maxShots = 0;      // Unlimited shots
        _maxSeries = 1;     // No series concept
        break;
      case "Entraînement dirigé":
        _timeRemaining = 60; // 1 minute in seconds
        _maxShots = 10;      // 10 shots (would vary by weapon type)
        _maxSeries = 2;      // 2 series
        break;
      case "Entraînement compétition":
        _timeRemaining = 30; // 30 seconds
        _maxShots = 10;      // Shots would vary by weapon type
        _maxSeries = 1;      // 1 series
        break;
      default:
        _timeRemaining = 60;
        _maxShots = 10;
        _maxSeries = 1;
    }
  }
  
  void _startSession() {
  if (_isSessionActive) return;

  setState(() {
    _isSessionActive = true;
    _shots = [];
    _totalScore = 0;
    _accuracy = 0;
    _currentSeries = 1;
    _isSessionComplete = false;
  });

  // Démarrer les tirs aléatoires
  _startRandomShots();

  // Démarrer le timer si nécessaire
  if (_timeRemaining > 0) {
    _startTimer();
  }
}
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          if (widget.selectedMode != "Entraînement libre") {
            _endCurrentSeries();
          }
        }
      });
    });
  }
  
  void _endCurrentSeries() {
    if (_currentSeries < _maxSeries) {
      // Move to next series
      setState(() {
        _currentSeries++;
        // Reset timer for the next series
        switch (widget.selectedMode) {
          case "Entraînement dirigé":
            _timeRemaining = 60;
            break;
          case "Entraînement compétition":
            _timeRemaining = 30;
            break;
          default:
            _timeRemaining = 0;
        }
      });
      
      if (_timeRemaining > 0) {
        _startTimer();
      }
    } else {
      // End session
      _completeSession();
    }
  }
  
  void _recordShot(double x, double y) {
    if (!_isSessionActive || _isSessionComplete) return;
    
    // Check if we've reached max shots for current series
    if (_maxShots > 0 && _shots.where((shot) => shot.series == _currentSeries).length >= _maxShots) {
      _endCurrentSeries();
      return;
    }
    
    // Calculate score based on distance from center
    final centerX = 150.0; // Assuming target is 300x300 with center at 150,150
    final centerY = 150.0;
    final distance = _calculateDistance(x, y, centerX, centerY);
final radiusString = widget.selectedTarget['radius'].replaceAll(RegExp(r'[^0-9.]'), ''); // Supprime tout sauf les chiffres et le point
final radius = double.parse(radiusString); // Convertit en double
final score = _calculateScore(distance, radius); // Utilise le rayon nettoyé    
    setState(() {
      _shots.add(Shot(
        x: x,
        y: y,
        score: score,
        series: _currentSeries,
        timestamp: DateTime.now(),
      ));
      
      _totalScore += score;
      _calculateAccuracy();
    });
    
    // Check if we've reached max shots for this mode/series
    if (_maxShots > 0 && _shots.where((shot) => shot.series == _currentSeries).length >= _maxShots) {
      _endCurrentSeries();
    }
  }
  
  double _calculateDistance(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2));
  }
  
  double _calculateScore(double distance, double targetRadius) {
    // Simple scoring logic: closer to center = higher score
    // Assuming target radius defines the 10-point zone
    if (distance <= targetRadius * 0.1) return 10.0;
    if (distance <= targetRadius * 0.2) return 9.0;
    if (distance <= targetRadius * 0.3) return 8.0;
    if (distance <= targetRadius * 0.4) return 7.0;
    if (distance <= targetRadius * 0.5) return 6.0;
    if (distance <= targetRadius * 0.6) return 5.0;
    if (distance <= targetRadius * 0.7) return 4.0;
    if (distance <= targetRadius * 0.8) return 3.0;
    if (distance <= targetRadius * 0.9) return 2.0;
    if (distance <= targetRadius) return 1.0;
    return 0.0; // Missed the target
  }
  
  void _calculateAccuracy() {
    if (_shots.isEmpty) {
      _accuracy = 0;
      return;
    }
    
    // Calculate what percentage of shots scored at least 7 points
    final goodShots = _shots.where((shot) => shot.score >= 7).length;
    _accuracy = (goodShots / _shots.length) * 100;
  }
  
void _completeSession() {
  _timer?.cancel();
  setState(() {
    _isSessionActive = false;
    _isSessionComplete = true;
  });
  
  // Naviguer vers la page de statistiques
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
}
  void _resetSession() {
    _timer?.cancel();
    setState(() {
      _isSessionActive = false;
      _isSessionComplete = false;
      _shots = [];
      _totalScore = 0;
      _accuracy = 0;
      _currentSeries = 1;
      _initializeSessionParameters();
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Fond camouflage - SVG
        SvgPicture.asset(
          '../assets/4.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        Column(
          children: [
            // En-tête
            NavBar(),
            // Contenu principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Session d\'entraînement',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                        _buildTimerWidget(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode: ${widget.selectedMode}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Cible: ${widget.selectedTarget['name']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Série: $_currentSeries / $_maxSeries',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              if (_maxShots > 0)
                                Text(
                                  'Tirs: ${_shots.where((shot) => shot.series == _currentSeries).length} / $_maxShots',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        _buildControlButtons(),
                      ],
                    ),
                    SizedBox(height: 24),
                    Expanded(
                      child: _buildTargetWithShots(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildTimerWidget() {
    final isTimeLimited = widget.selectedMode != "Entraînement libre";
    
    if (!isTimeLimited && !_isSessionActive) {
      return Container();
    }
    
    final minutes = _timeRemaining ~/ 60;
    final seconds = _timeRemaining % 60;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _timeRemaining < 10 && _timeRemaining > 0
            ? Colors.red.withOpacity(0.3)
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: isTimeLimited
          ? Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _timeRemaining < 10 && _timeRemaining > 0
                    ? Colors.red
                    : Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Illimité',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
  
 // Dans la méthode _buildControlButtons()
Widget _buildControlButtons() {
  return Row(
    children: [
      if (!_isSessionActive)
        ElevatedButton.icon(
          onPressed: _startSession,
          icon: Icon(Icons.play_arrow),
          label: Text('Commencer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.7),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        )
      else
        ElevatedButton.icon(
          onPressed: _completeSession,
          icon: Icon(Icons.stop),
          label: Text('Terminer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.7),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
    ],
  );
}
 
 Widget _buildTargetWithShots() {
  return Center(
    child: Stack(
      alignment: Alignment.center, // Centre la cible et les tirs
      children: [
        // Base SVG target
        GestureDetector(
          onTapDown: _isSessionActive ? (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);

            // Ajuster les coordonnées pour qu'elles soient relatives au centre de la cible
            final targetCenterX = 200; // Centre de la cible (400x400)
            final targetCenterY = 200;
            final offsetX = localPosition.dx - (MediaQuery.of(context).size.width / 2 - targetCenterX);
            final offsetY = localPosition.dy - (MediaQuery.of(context).size.height / 2 - targetCenterY);

            // Enregistrer le tir si les coordonnées sont dans la zone de la cible
            if (offsetX >= 0 && offsetX <= 400 && offsetY >= 0 && offsetY <= 400) {
              _recordShot(offsetX, offsetY);
            }
          } : null,
          child: SvgPicture.string(
            widget.selectedTarget['svg'],
            width: 400, // Taille de la cible agrandie
            height: 400,
          ),
        ),

        // Afficher les tirs
        ..._shots
            .where((shot) => shot.series == _currentSeries)
            .map((shot) => Positioned(
                  left: shot.x - 5, // Ajuster la position du tir
                  top: shot.y - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getShotColor(shot.score),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ))
            ,

        // Overlay d'instructions si la session n'est pas active
        if (!_isSessionActive && !_isSessionComplete)
          Container(
            width: 400,
            height: 400,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, color: Colors.white, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Appuyez sur "Commencer" pour démarrer la session',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
Color _getShotColor(double score) {
  if (score >= 9) return Colors.red;
  if (score >= 7) return Colors.orange;
  if (score >= 5) return Colors.yellow;
  if (score >= 3) return Colors.green;
  return Colors.blue;
}
  
  Widget _buildStatisticsPanel() {
    final seriesData = List.generate(_maxSeries, (index) => index + 1)
        .map((series) {
          final seriesShots = _shots.where((shot) => shot.series == series).toList();
          if (seriesShots.isEmpty) {
            return {'series': series, 'score': 0.0, 'accuracy': 0.0, 'shots': 0};
          }
          
          final seriesScore = seriesShots.fold<double>(0, (sum, shot) => sum + shot.score);
          final seriesAccuracy = (seriesShots.where((shot) => shot.score >= 7).length / seriesShots.length) * 100;
          
          return {
            'series': series, 
            'score': seriesScore, 
            'accuracy': seriesAccuracy, 
            'shots': seriesShots.length
          };
        }).toList();
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Résultats de la session',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                'Score Total', 
                _totalScore.toStringAsFixed(1), 
                icon: Icons.score,
              ),
              _buildStatCard(
                'Précision', 
                '${_accuracy.toStringAsFixed(1)}%', 
                icon: Icons.precision_manufacturing,
              ),
              _buildStatCard(
                'Tirs', 
                '${_shots.length}', 
                icon: Icons.track_changes,
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Résultats par série',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: seriesData.length,
              itemBuilder: (context, index) {
                final data = seriesData[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text('${data['series']}'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Série ${data['series']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Score: ${(data['score'] as double).toStringAsFixed(1)} | Précision: ${(data['accuracy'] as double).toStringAsFixed(1)}% | Tirs: ${data['shots']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
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
    );
  }
  
  Widget _buildStatCard(String title, String value, {required IconData icon}) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, bool isActive) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: isActive ? Colors.black.withOpacity(0.3) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: isActive ? BorderSide(color: Colors.white.withOpacity(0.3)) : BorderSide.none,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

