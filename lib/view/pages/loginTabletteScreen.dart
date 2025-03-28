import 'package:cible_militaire/view/routes.dart';
import 'package:cible_militaire/view/widgets/drop-downList.dart';
import 'package:cible_militaire/view/widgets/inputField.dart';
import 'package:cible_militaire/view/widgets/largeButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

 class LoginTabletMilitaryScreen extends StatefulWidget {
  const LoginTabletMilitaryScreen({super.key});

  @override
  _LoginTabletMilitaryScreenState createState() => _LoginTabletMilitaryScreenState();
}

class _LoginTabletMilitaryScreenState extends State<LoginTabletMilitaryScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _NumlisteController = TextEditingController();
  final TextEditingController _BdeNumlisteController = TextEditingController();

  final List<String> promotion_list = ['INVITÉ(E)','1ère ANNÉE', '2ème ANNÉE', '3ème ANNÉE', 'CYCLE SPÉCIAL','4ème ANNÉE'];
  final List<String> brigade_list = ['N°1', 'N°2', 'N°3', 'N°4','N°5', 'N°6', 'N°7', 'N°8','N°9', 'N°10', 'N°11', 'N°12'];
  String promotion = "PROMOTION";
  String brigade = "BRIGADE";
  final String _hintListe = 'Vous ètes en mode invitée';
  bool isCreateMode = false;
  bool isInvite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond camouflage - couleur solide olive militaire
          SvgPicture.asset(
            '../assets/1.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Interface principale
          Row(
            children: [
              // Panneau gauche avec logos
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo losange rouge (gauche)
                         SizedBox(width: 20), // Push logo to the right

                          buildDiamondLogo(),
                          Container(
                            width: 1,
                            height: 120,
                            color: Colors.white,
                          ),
                          SizedBox(width: 22),
                          // Logo blason (droite)
                          buildShieldLogo(),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        '100ème Promotion',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Panneau droit avec formulaire
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  padding: EdgeInsets.symmetric(horizontal: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // En-tête Login | Create
                      Row(
                        children: [
                          InkWell(
                            child: 
                            Text('Login',
                              style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: isCreateMode ? Colors.grey : Colors.white,
                            )),
                            onTap: () {
                                setState(() {
                                 isCreateMode = false;
                              });
                            },
                            onHover: (value) {
                            },
                          ),
                         
                          InkWell(
                            child: 
                            Text(' | Create',
                              style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: isCreateMode ?   Colors.white : Colors.grey,
                            )),
                            onTap: () {
                                setState(() {
                                 isCreateMode = true;
                              });
                            },
                            onHover: (value) {
                            },
                          )
                          
                        ],
                      ),
                      SizedBox(height: 24),

                      // Champ utilisateur - Nom et Prénom sur la même ligne
                      Row(
                        children: [
                          // Champ Nom
                          inputField ( _nomController, "Nom"),

                          SizedBox(width: 16), // Espace entre les deux champs
                          // Champ Prénom
                          inputField ( _prenomController, "Prenom"),

                        ],
                      ),
                      SizedBox(height: 16), // Espace après la ligne
                      if(isCreateMode)
                      Row(
                        children: [
  
                          // Champ Nom
                        StyledDropdown( 
                            items: promotion_list , hintText: promotion,
                            onChanged: (String? newValue) {
                            setState(() {
                              promotion = newValue! ;
                              if (newValue == "INVITÉ(E)") {
                                isInvite = true;
                              } else {
                                isInvite = false;
                              }       

                             });}
                            ),
                         

                          SizedBox(width: 16), // Espace entre les deux champs
                          // Champ Prénom
                     
                        StyledDropdown( 
                            items: brigade_list , hintText: brigade,
                            onChanged: (String? newValue) {
                            setState(() {
                              brigade = newValue! ;
                          });}
                            ),
                        

                        ],

                      ),

                      if(isCreateMode)
                      SizedBox(height: 16),
                      // Sélecteur de liste avec position relative pour le dropdown
                      Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _NumlisteController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: isInvite? _hintListe : "N° Liste",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: InputBorder.none,
                                ),
                                readOnly: isInvite
                              ),
                            ),


                      SizedBox(height: 16),
                      
                      // Sélecteur de BDE avec position relative pour le dropdown
                       Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _BdeNumlisteController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:  isInvite? _hintListe :"Bde",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: InputBorder.none,
                                ),
                                readOnly: isInvite

                              ),
                            ),

                      SizedBox(height: 24),
                      // Bouton Start
                      Largebutton("START", AppRoutes.laneselection)
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

  

  // Fonction pour construire le logo losange rouge avec l'étoile verte
  Widget buildDiamondLogo() {
    return SizedBox(
      width: 140,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lueur autour du losange
          
          // Losange rouge
          Image.asset(
            '../assets/log_gauche.png',
            fit: BoxFit.cover,
            width: 140,
            height: 160,
          ),
        ],
      ),
    );
  }

  // Fonction pour construire le blason/bouclier
  Widget buildShieldLogo() {
    return SizedBox(
      width: 180,
      height: 182,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lueur autour du bouclier
        
          Image.asset(
            '../assets/far_logo.png',
            fit: BoxFit.cover,
            width: 180,
            height: 182,
          ),
        ],
      ),
    );
  }
}