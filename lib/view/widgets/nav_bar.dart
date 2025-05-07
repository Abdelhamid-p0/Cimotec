import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cible_militaire/controller/user_session.dart';
import 'package:cible_militaire/view/widgets/Apropos.dart';
import 'package:cible_militaire/view/widgets/Historique.dart';
import 'package:cible_militaire/view/widgets/InfosCompte.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Timer? _timer;
  String _currentTime = "00:00";

  @override
  void initState() {
    super.initState();
    _startTimeUpdater();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimeUpdater() {
    _updateTime(); // Mise à jour immédiate
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

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
                        const SizedBox(width: 20),
                        buildDiamondLogo(),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
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
                      showMilitaryThemedAboutDialog(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, size: 24, color: Colors.white70),
                    onPressed: () {
                      showPlayerInfoDialog(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.history, size: 24, color: Colors.white70),
                    onPressed: () {
                      showShootingStatsDialog(context);
                    },
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
                  const Text('Ayman', style: TextStyle(color: Colors.white70)),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 20, color: Colors.white70),
                    onPressed: () {},
                  ),
                  Text(_currentTime, style: const TextStyle(color: Colors.white70)),
                  IconButton(
                    icon: const Icon(Icons.brightness_1, size: 12, color: Color.fromARGB(253, 12, 240, 23)),
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
      ],
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

Widget buildDiamondLogo() {
  return SizedBox(
    width: 40,
    height: 60,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/log_gauche.png',
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
          'assets/far_logo.png',
          fit: BoxFit.cover,
          width: 60,
          height: 62,
        ),
      ],
    ),
  );
}