//infos compte popup
import 'package:cible_militaire/controller/user_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

showPlayerInfoDialog(BuildContext context) {
  final userSession = Provider.of<UserSession>(context, listen: false);
  final player = userSession.currentUser;

  // Couleurs militaires
  const Color militaryDarkGreen = Color(0xFF3A4A1F);
  const Color militaryLightGreen = Color(0xFF6B7B3D);
  const Color militaryBrown = Color(0xFF5D4037);
  const Color militaryBeige = Color(0xFFE8E1D7);
  const Color militaryGold = Color(0xFFD4AF37);

  final bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Dialog(
          insetPadding: EdgeInsets.all(isTablet ? 30 : 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: militaryBrown, width: 3),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600 : 400,
            ),
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
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
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
                        Icon(Icons.military_tech, color: militaryGold, size: isTablet ? 32 : 28),
                        SizedBox(width: isTablet ? 16 : 12),
                        Flexible(
                          child: Text(
                            'INFORMATIONS DU COMPTE',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Icon(Icons.military_tech, color: militaryGold, size: isTablet ? 32 : 28),
                      ],
                    ),
                  ),
                ),

                // Contenu - Informations du compte uniquement
                Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    children: [
                      _buildInfoRow('Nom', player?.nom ?? '--'),
                      _buildDivider(),
                      _buildInfoRow('Prénom', player?.prenom ?? '--'),
                      _buildDivider(),
                      _buildInfoRow('Promotion', player?.promotion ?? '--'),
                      _buildDivider(),
                      _buildInfoRow('Brigade', player?.brigade ?? '--'),
                      _buildDivider(),
                      _buildInfoRow('Numéro de liste', player?.numeroListe ?? '--'),
                      _buildDivider(),
                      _buildInfoRow('BDE', player?.bdeNumeroListe ?? '--'),
                    ],
                  ),
                ),

                // Bouton de fermeture
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
                      minimumSize: Size(double.infinity, isTablet ? 56 : 48),
                    ),
                    child: Text(
                      'FERMER',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
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

 

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFF5D4037),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDivider() {
  return Divider(
    height: 1,
    thickness: 1,
    color: Color(0xFF5D4037).withOpacity(0.1),
    indent: 16,
    endIndent: 16,
  );
}