import 'package:flutter/material.dart';

class LoginTabletMilitaryScreen extends StatefulWidget {
  const LoginTabletMilitaryScreen({super.key});

  @override
  _LoginTabletMilitaryScreenState createState() => _LoginTabletMilitaryScreenState();
}

class _LoginTabletMilitaryScreenState extends State<LoginTabletMilitaryScreen> {
  final TextEditingController _userController = TextEditingController();
  String _selectedRole = 'Administrator';
  final List<String> _roles = ['Administrator', 'Utilisateur', 'Formateur', 'Observateur'];
  bool _showRoles = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec image militaire
          Positioned.fill(
            child: Image.asset(
              '../assets/backrougnde.png',
              fit: BoxFit.cover,
            ),
          ),

          // Effet de verre (Glassmorphism)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          Center(
            child: Container(
              width: 700,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDiamondLogo(),
                      SizedBox(width: 30),
                      buildShieldLogo(),
                    ],
                  ),
                  SizedBox(height: 24),

                  Text(
                    '100ème Promotion',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),

                  buildTextField('User', Icons.person_outline),
                  SizedBox(height: 16),

                  buildRoleSelector(),
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'CREATE',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _userController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget buildRoleSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showRoles = !_showRoles),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedRole, style: TextStyle(color: Colors.white70)),
                Icon(_showRoles ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white70),
              ],
            ),
          ),
        ),
        if (_showRoles)
          Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: _roles.map((role) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedRole = role;
                    _showRoles = false;
                  }),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      role,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: _selectedRole == role ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget buildDiamondLogo() {
    return Image.asset(
      '../assets/log_gauche.png',
      width: 100,
    );
  }

  Widget buildShieldLogo() {
    return Image.asset(
      '../assets/far_logo.png',
      width: 100,
    );
  }
}
