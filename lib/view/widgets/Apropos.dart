import 'package:flutter/material.dart';

void showMilitaryThemedAboutDialog(BuildContext context) {
  // Couleurs militaires
  const Color militaryDarkGreen = Color(0xFF3A4A1F);
  const Color militaryLightGreen = Color(0xFF6B7B3D);
  const Color militaryBrown = Color(0xFF5D4037);
  const Color militaryBeige = Color(0xFFE8E1D7);
  const Color militaryGold = Color(0xFFD4AF37);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: militaryBrown, width: 3),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Limite de hauteur
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [militaryLightGreen.withOpacity(0.1), militaryDarkGreen.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // En-tête
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [militaryDarkGreen, militaryLightGreen],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.military_tech, color: militaryGold, size: 28),
                        SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'À PROPOS DE CIMOTEC',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.military_tech, color: militaryGold, size: 28),
                      ],
                    ),
                  ),
                ),

                // Contenu avec défilement
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAboutSection(
                          title: 'QUI SOMMES-NOUS ?',
                          content: 'Nous sommes une équipe d\'élèves officiers passionnés par la conception et la fabrication de systèmes mécaniques et électroniques. Dans le cadre de notre projet de fin d\'études, nous avons développé CIMOTEC, une cible mobile innovante montée sur chenilles, conçue pour répondre aux besoins d\'entraînement, de simulation et de tests dynamiques.',
                        ),
                        
                        SizedBox(height: 16),
                        
                        _buildAboutSection(
                          title: 'L\'ÉQUIPE',
                          content: '',
                          children: [
                            _buildTeamMember('Professeur encadrant', 'BOUAYAD Aboubakr'),
                            _buildTeamMember('Elève officier', 'ELBERKOUKI Ayman'),
                            _buildTeamMember('Elève officier', 'CHINKHIR BILAL'),
                            _buildTeamMember('Elève officier', 'BOUFTAT BILAL'),
                            _buildTeamMember('Elève officier', 'IBRAHIMI KAOUTAR'),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        _buildAboutSection(
                          title: 'POURQUOI "CIMOTEC" ?',
                          content: 'Le nom CIMOTEC est une combinaison des termes qui définissent notre projet :',
                          children: [
                            _buildBulletPoint('CI pour Cible mobile'),
                            _buildBulletPoint('MO pour Montée sur chenilles'),
                            _buildBulletPoint('TEC pour Télécommandée à distance'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Pied de page
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [militaryLightGreen, militaryDarkGreen],
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: militaryGold,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      'FERMER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildAboutSection({
  required String title,
  required String content,
  List<Widget> children = const [],
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFF4B5320),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(height: 8),
      if (content.isNotEmpty) Text(
        content,
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      ...children,
    ],
  );
}

Widget _buildTeamMember(String role, String name) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.person, size: 16, color: Color(0xFF5D4037)),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(
                  text: '$role : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
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

Widget _buildBulletPoint(String text) {
  return Padding(
    padding: EdgeInsets.only(left: 16, bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.fiber_manual_record, size: 12, color: Color(0xFF5D4037)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}