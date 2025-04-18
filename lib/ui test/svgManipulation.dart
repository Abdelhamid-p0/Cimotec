/*import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVG Interactif',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SVGInteractiveScreen(),
    );
  }
}

class SVGInteractiveScreen extends StatefulWidget {
  const SVGInteractiveScreen({Key? key}) : super(key: key);

  @override
  State<SVGInteractiveScreen> createState() => _SVGInteractiveScreenState();
}

class _SVGInteractiveScreenState extends State<SVGInteractiveScreen> {
  // État pour suivre la couleur de chaque section
  Color section1Color = Colors.black;
  Color section2Color = Colors.black;
  Color section3Color = Colors.black;

  // Timer pour l'effet de clignotement
  Timer? _blinkTimer;
  bool _isBlinking = false;

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  // Fonction pour faire clignoter la section 1
  void _blinkSection1() {
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
    });

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        section1Color = section1Color == Colors.black ? Colors.red : Colors.black;
      });
    });
  }

void _blinkSection2() {
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
    });

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        section2Color = section2Color == Colors.black ? Colors.red : Colors.black;
      });
    });
  }
  void _blinkSection3() {
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
    });

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        section3Color = section3Color == Colors.black ? Colors.red : Colors.black;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Interactif'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 500,
              child: Stack(
                children: [
                  // SVG complet avec des sections interactives
                  SvgPicture.string(
                    _buildSvgString(),
                    width: 300,
                    height: 500,
                  ),
                  
                  // Zones cliquables transparentes superposées
                  Positioned.fill(
                    child: Column(
                      children: [
                        // Zone cliquable pour la section 1 (tête)
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              _blinkSection1();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Section 1 (Tête) cliquée!')),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        // Zone cliquable pour la section 2 (extrémité)
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: () {
                              _blinkSection2();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Section 2 (Extrémité) cliquée!')),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        // Zone cliquable pour la section 3 (ventre)
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                                                            _blinkSection3();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Section 3 (Ventre) cliquée!')),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [ElevatedButton(
              onPressed: _blinkSection1,
              child: Text(_isBlinking ? 'Arrêter le clignotement' : 'Faire clignoter la section 1'),
            ),
            ElevatedButton(
              onPressed: _blinkSection2,
              child: Text(_isBlinking ? 'Arrêter le clignotement' : 'Faire clignoter la section 1'),
            ),
            ElevatedButton(
              onPressed: _blinkSection3,
              child: Text(_isBlinking ? 'Arrêter le clignotement' : 'Faire clignoter la section 1'),
            )],)
            
          ],
        ),
      ),
    );
  }

  // Construit la chaîne SVG avec les couleurs actuelles
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

  // Convertit un objet Color Flutter en valeur hexadécimale pour SVG
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}*/