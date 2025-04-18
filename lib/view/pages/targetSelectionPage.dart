import 'package:cible_militaire/view/routes.dart';
import 'package:cible_militaire/view/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrainingModePage extends StatefulWidget {
  const TrainingModePage({super.key, required this.selectedCoups});
 final int selectedCoups;

  @override
  State<TrainingModePage> createState() => _TrainingModePageState();
}

class _TrainingModePageState extends State<TrainingModePage> {
  String selectedMode = 'Entraînement libre';
  int selectedTargetIndex = 0;

  
final List<Map<String, dynamic>> targets = [
   {
    'name': 'Cible ARM',
    'radius': 'N/A',
    'svg': '''
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 viewBox="0 0 369 604" preserveAspectRatio="xMidYMid meet">
<g transform="translate(0,604) scale(0.1,-0.1)" fill="#000000" stroke="none">
  
  <!-- Séction 1 Tète -->
  <path d="M1340 5918 c-30 -28 -90 -84 -133 -124 l-77 -73 2 -538 3 -538 710 0
  710 0 3 530 2 530 -137 132 -138 132 -445 0 -445 0 -55 -51z"/>
  
  <!-- Séction 2: Extremité -->
  <path d="M440 4419 c-118 -105 -250 -223 -292 -261 l-78 -70 1 -1747 0 -1746
  140 -125 c77 -69 211 -189 297 -267 l157 -142 518 -1 517 0 0 470 0 470 -164
  0 -164 0 -146 136 c-80 75 -146 142 -146 148 0 6 0 539 0 1184 l0 1174 87 82
  c49 45 111 103 139 129 l51 47 491 0 492 0 145 -132 145 -133 -1 -1185 -1
  -1185 -52 -45 c-28 -25 -86 -76 -128 -113 -42 -37 -86 -77 -99 -87 -20 -18
  -38 -20 -186 -20 l-163 0 0 -470 0 -470 514 0 515 0 238 216 c131 120 264 241
  295 271 l58 54 0 1743 0 1744 -67 58 c-38 32 -75 65 -83 73 -8 8 -106 95 -217
  193 -111 98 -205 183 -208 188 -4 6 -436 10 -1198 10 l-1193 0 -214 -191z"/>
  
  <!-- Séction 3: Ventre -->
  <path d="M1233 3757 l-132 -122 -1 -1176 0 -1176 37 -33 c21 -19 82 -76 136
  -127 l99 -93 480 0 479 0 140 126 139 126 0 1167 0 1167 -67 65 c-38 36 -101
  95 -142 132 l-73 67 -482 0 -481 -1 -132 -122z"/>
  <path d="M1730 530 l0 -470 125 0 125 0 0 470 0 470 -125 0 -125 0 0 -470z"/>

</g>
</svg>
    '''
  } ,
  {
    'name': 'Cible silhouette',
    'radius': '24.00 mm',
    'svg': '''
<svg viewBox="0 0 200 300" xmlns="http://www.w3.org/2000/svg">
  <!-- Grande forme extérieure -->
  <polygon points="50,20 150,20 180,60 180,230 150,280 50,280 20,230 20,60" fill="{{outer}}" stroke="white" stroke-width="2"/>
  <!-- Section intermédiaire -->
  <polygon points="70,70 130,70 150,110 150,210 130,250 70,250 50,210 50,110" fill="{{middle}}" stroke="white" stroke-width="2"/>
  <!-- Section supérieure (tête agrandie) -->
  <polygon points="75,-10 125,-10 125,50 75,50" fill="{{head}}" stroke="white" stroke-width="2"/>
  <!-- Deux lignes verticales en bas -->
  <line x1="90" y1="250" x2="90" y2="280" stroke="white" stroke-width="2"/>
  <line x1="110" y1="250" x2="110" y2="280" stroke="white" stroke-width="2"/>
</svg>
    '''
  },
  {
    'name': 'Cible standard',
    'radius': '22.75 mm',
    'svg': '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="90" stroke="black" stroke-width="5" fill="white"/>
  <circle cx="100" cy="100" r="60" stroke="black" stroke-width="5" fill="white"/>
  <circle cx="100" cy="100" r="30" stroke="black" stroke-width="5" fill="white"/>
  <circle cx="100" cy="100" r="10" stroke="black" stroke-width="5" fill="black"/>
</svg>
    '''
  },
  {
    'name': 'Cible precision',
    'radius': '20.50 mm',
    'svg': '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="90" stroke="black" stroke-width="3" fill="white"/>
  <circle cx="100" cy="100" r="75" stroke="black" stroke-width="2" fill="white"/>
  <circle cx="100" cy="100" r="60" stroke="black" stroke-width="2" fill="white"/>
  <circle cx="100" cy="100" r="45" stroke="black" stroke-width="2" fill="white"/>
  <circle cx="100" cy="100" r="30" stroke="black" stroke-width="2" fill="white"/>
  <circle cx="100" cy="100" r="15" stroke="black" stroke-width="2" fill="black"/>
  <circle cx="100" cy="100" r="5" stroke="white" stroke-width="1" fill="white"/>
</svg>
    '''
  },
 
];

  
  @override
  Widget build(BuildContext context) {
    
    int selectedCoups = widget.selectedCoups;

    return Scaffold(
      body: Stack(
        children: [
          // Fond camouflage - SVG
          SvgPicture.asset(
            '../assets/3.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Column(
            children: [
              // En-tête
             NavBar(),
              // Contenu principal en disposition horizontale
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section de sélection de mode d'entraînement (gauche)
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode d\'Entraînement',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Options de mode d'entraînement
                              _buildModeSelection('Entraînement libre'),
                              _buildModeSelection('Entraînement dirigé par Officier De Tir'),
                              _buildModeSelection('Entraînement compétition'),
                              
                              const SizedBox(height: 24),
                              
                              // Caractéristiques du mode sélectionné
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: _buildModeCharacteristics(selectedCoups),
                              ),
                              
                              const Spacer(),
                              
                              // Bouton START
Center(
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.pushNamed(
        context,
        AppRoutes.trainingSession,
        arguments: {
          'selectedMode': selectedMode,
          'selectedTarget': targets[selectedTargetIndex], // Pass the selected target object
        },
      );
    },
    icon: const Icon(Icons.play_arrow),
    label: const Text('START'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  ),
),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Section de la cible avec carousel (droite)
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                'Sélectionner la cible',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Carousel de cibles
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CarouselSlider(
                                      options: CarouselOptions(
                                        height: 250,
                                        enlargeCenterPage: true,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            selectedTargetIndex = index;
                                          });
                                        },
                                        initialPage: selectedTargetIndex,
                                        enableInfiniteScroll: true,
                                        autoPlay: false,
                                        viewportFraction: 0.8,
                                      ),
                                      items: targets.map((target) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: MediaQuery.of(context).size.width,
                                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: SvgPicture.string(
                                                  target['svg'],
                                                  width: 200,
                                                  height: 200,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Informations sur la cible sélectionnée
                                    Text(
                                      targets[selectedTargetIndex]['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Rayon: ${targets[selectedTargetIndex]['radius']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Indicateurs de position
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: targets.asMap().entries.map((entry) {
                                        return Container(
                                          width: 12.0,
                                          height: 12.0,
                                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: selectedTargetIndex == entry.key
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildModeSelection(String mode) {
    final isSelected = selectedMode == mode;
    
    return InkWell(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: mode,
              groupValue: selectedMode,
              onChanged: (value) {
                setState(() {
                  selectedMode = value!;
                });
              },
              fillColor: WidgetStateProperty.resolveWith(
                (states) => Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                mode,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCharacteristics(int selectedCoups) {
    switch (selectedMode) {
      case 'Entraînement libre':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entraînement libre',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CharacteristicItem(label: 'Sans limite', value: 'temps'),
                _CharacteristicItem(label: 'Illimité', value: 'de coups'),
                _CharacteristicItem(label: 'Sans', value: 'séries'),
              ],
            ),
          ],
        );
      
      case 'Entraînement dirigé par Officier De Tir':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entraînement dirigé',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _CharacteristicItem(label: '1:00', value: 'une minute'),
                _CharacteristicItem(label: 'Nombre de coups', value: selectedCoups.toString()),
                const _CharacteristicItem(label: '2', value: 'séries'),
              ],
            ),
          ],
        );
      
      case 'Entraînement compétition':
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entraînement compétition',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CharacteristicItem(label: '0:30', value: '30 secondes'),
                _CharacteristicItem(label: 'Nombre de coups', value: selectedCoups.toString()),
                _CharacteristicItem(label: '1', value: 'série'),
              ],
            ),
          ],
        );
      
      default:
        return const SizedBox.shrink();
    }
  }
}

class _CharacteristicItem extends StatelessWidget {
  final String label;
  final String value;
  
  const _CharacteristicItem({
    required this.label,
    required this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}