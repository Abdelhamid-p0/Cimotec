import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  
  @override
  Widget build(BuildContext context) { 
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section gauche avec logo et titre
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo losange rouge (gauche)
                        SizedBox(width: 20), // Push logo to the right
                        buildDiamondLogo(),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        // Logo blason (droite)
                        buildShieldLogo(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CIMOTEC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '100 ème promotion',
                        style: TextStyle(
                          fontSize: 12, 
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Section droite avec boutons d'action
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.help_outline, size: 24, color: Colors.white70),
                    onPressed: () {
                      _showMilitaryThemedAboutDialog(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, size: 24, color: Colors.white70),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, size: 24, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          color: Colors.black.withOpacity(0.2),
          child: Row(
            children: [
              _buildNavButton('Start', true),
              _buildNavButton('Review', false),
              _buildNavButton('Manage', false),
              const Spacer(),
              // Informations utilisateur
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 12,
                  ),
                  const SizedBox(width: 8),
                  const Text('User', style: TextStyle(color: Colors.white70)),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 20, color: Colors.white70),
                    onPressed: () {},
                  ),
                  const Text('12 : 26', style: TextStyle(color: Colors.white70)),
                  IconButton(
                    icon: const Icon(Icons.brightness_1, size: 12, color: Colors.white70),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, size: 24, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        )
      ]       
    );  
  }
  
  // Function to show the Military-themed About Dialog
  void _showMilitaryThemedAboutDialog(BuildContext context) {
    // Couleurs militaires
    const Color militaryGreen = Color(0xFF4B5320);
    const Color militaryLightGreen = Color(0xFF6B7B3D);
    const Color militaryBrown = Color(0xFF5D4037);
    const Color militaryBeige = Color(0xFFD7CCC8);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: militaryBrown, width: 3),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: militaryBeige,
              image: DecorationImage(
                image: AssetImage('../assets/camouflage_background.jpg'), // Ajoutez une image de camouflage
                fit: BoxFit.cover,
                opacity: 0.2, // Opacité pour la lisibilité du texte
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // En-tête avec style militaire
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const BoxDecoration(
                    color: militaryGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.stars, // Icône militaire
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'CIMOTEC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.stars, // Icône militaire
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                // Contenu
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                            child: Text(
                              'À PROPOS DE NOUS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: militaryGreen,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildMilitaryHeading('Qui sommes-nous ?'),
                          const SizedBox(height: 5),
                          const Text(
                            'Nous sommes une équipe d\'élèves officiers passionnés par la conception et la fabrication de systèmes mécaniques et électroniques. Dans le cadre de notre projet de fin d\'études, nous avons développé CIMOTEC, une cible mobile innovante montée sur chenilles, conçue pour répondre aux besoins d\'entraînement, de simulation et de tests dynamiques.',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 15),
                          _buildMilitaryHeading('Les Réalisateurs du Projet'),
                          const SizedBox(height: 5),
                          _buildPersonnelInfo('Professeur encadrant', 'BOUAYAD Aboubakr'),
                          _buildPersonnelInfo('Elève officier', 'ELBERKOUKI Ayman'),
                          _buildPersonnelInfo('Elève officier', 'CHINKHIR BILAL'),
                          _buildPersonnelInfo('Elève officier', 'BOUFTAT BILAL'),
                          _buildPersonnelInfo('Elève officier', 'IBRAHIMI KAOUTAR'),
                          const SizedBox(height: 15),
                          _buildMilitaryHeading('Pourquoi "CIMOTEC" ?'),
                          const SizedBox(height: 5),
                          const Text(
                            'Le nom CIMOTEC est une combinaison des termes qui définissent notre projet :',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 5),
                          _buildBulletPoint('CI pour Cible mobile'),
                          _buildBulletPoint('MO pour Montée sur chenilles'),
                          _buildBulletPoint('TEC pour Télécommandée à distance'),
                          const SizedBox(height: 10),
                          const Text(
                            'Ce nom reflète notre vision d\'une cible mobile innovante, robuste et technologique, capable de répondre aux besoins d\'entraînement et de simulation avec précision et efficacité.',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Nous croyons que CIMOTEC représente l\'avenir des systèmes mobiles autonomes et nous sommes fiers de partager cette innovation avec vous !',
                            style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Pied de page avec bouton de fermeture
                Container(
                  decoration: const BoxDecoration(
                    color: militaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'FERMER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Helper method to build military-style headings
  Widget _buildMilitaryHeading(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4B5320),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
  
  // Helper method to build personnel information
  Widget _buildPersonnelInfo(String role, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: Color(0xFF4B5320),
            size: 20,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: '$role : ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: name),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build bullet points
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF5D4037),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
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

// Fonction pour construire le logo losange rouge avec l'étoile verte
Widget buildDiamondLogo() {
  return SizedBox(
    width: 40,
    height: 60,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          '../assets/log_gauche.png',
          fit: BoxFit.cover,
          width: 40,
          height: 60,
        ),
      ],
    ),
  );
}

Widget buildShieldLogo() {
  return SizedBox(
    width: 60,
    height: 62,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          '../assets/far_logo.png',
          fit: BoxFit.cover,
          width: 60,
          height: 62,
        ),
      ],
    ),
  );
}