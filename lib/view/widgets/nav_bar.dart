import 'package:flutter/material.dart';

class NavBar  extends StatelessWidget{


    const NavBar ({super.key});
    
      @override
      Widget build(BuildContext context) { 
        return  Column(
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
                          child:                       Row(
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
                          onPressed: () {},
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

