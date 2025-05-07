import 'package:cible_militaire/controller/authentificationService.dart';
import 'package:cible_militaire/controller/user_session.dart';
import 'package:cible_militaire/view/routes.dart';
import 'package:cible_militaire/view/widgets/drop-downList.dart';
import 'package:cible_militaire/view/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fond camouflage - couleur solide olive militaire
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/1.svg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Interface principale
          SafeArea(
            child: Row(
              children: [
                // Panneau gauche avec logos
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black.withOpacity(0.15),
                    child:LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 20),
                            buildDiamondLogo(),
                            Container(
                              width: 1,
                              height: 120,
                              color: Colors.white,
                            ),
                            SizedBox(width: 22),
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
                        );
                      },
                    ),
                  ),
                ),

                // Panneau droit avec formulaire
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 600 ? 48.0 : 24.0,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // En-tête Login | Create
                                  Row(
                                    children: [
                                      InkWell(
                                        child: Text('Login',
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
                                      ),
                                     
                                      InkWell(
                                        child: Text(' | Create',
                                          style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.normal,
                                          color: isCreateMode ? Colors.white : Colors.grey,
                                        )),
                                        onTap: () {
                                            setState(() {
                                             isCreateMode = true;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 24),

                                  // Champ utilisateur - Nom et Prénom
                                  Row(
                                    children: [
                                      Expanded(
                                        child: inputField(_nomController, "Nom"),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: inputField(_prenomController, "Prenom"),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  
                                  if(isCreateMode) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: StyledDropdown( 
                                            items: promotion_list,
                                            hintText: promotion,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                promotion = newValue!;
                                                if (newValue == "INVITÉ(E)") {
                                                  isInvite = true;
                                                } else {
                                                  isInvite = false;
                                                }       
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: StyledDropdown( 
                                            items: brigade_list,
                                            hintText: brigade,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                brigade = newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                  
                                  // Sélecteur de liste
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
                                        hintText: isInvite ? _hintListe : "N° Liste",
                                        hintStyle: TextStyle(color: Colors.white70),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        border: InputBorder.none,
                                      ),
                                      readOnly: isInvite,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),

                                  SizedBox(height: 24),
                                  
                                  // Bouton Start
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        setState(() => _isLoading = true);
                                        
                                        try {
                                          if (isCreateMode) {
                                            bool isRegistered = await AuthService.registeringAuthentificationService(
                                              _nomController,
                                              _prenomController,
                                              _NumlisteController,
                                              _BdeNumlisteController,
                                              promotion,
                                              brigade,
                                            );
                                            
                                            if (isRegistered) {
                                              final players = await AuthService.readPlayerData();
                                              final loggedInUser = players.firstWhere(
                                                (p) => p.nom == _nomController.text && p.prenom == _prenomController.text
                                              );
                                              
                                              final userSession = Provider.of<UserSession>(context, listen: false);
                                              userSession.login(loggedInUser);
                                              
                                              print("Joueur connecté: ${loggedInUser.toString()}");
                                              Navigator.pushNamed(context, AppRoutes.laneSelection);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Erreur lors de l'inscription")),
                                              );
                                            }
                                          } else {
                                            bool isAuthenticated = await AuthService.checkingAuthentificationService(
                                              _nomController,
                                              _prenomController,
                                              _NumlisteController,
                                              _BdeNumlisteController,
                                            );
                                            
                                            if (isAuthenticated) {
                                              final players = await AuthService.readPlayerData();
                                              final loggedInUser = players.firstWhere(
                                                (p) => p.nom == _nomController.text && p.prenom == _prenomController.text
                                              );
                                              
                                              final userSession = Provider.of<UserSession>(context, listen: false);
                                              userSession.login(loggedInUser);
                                              
                                              print("Joueur authentifié: ${loggedInUser.toString()}");
                                              Navigator.pushNamed(context, AppRoutes.laneSelection);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Authentification échouée")),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          print("Erreur: $e");
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Une erreur est survenue")),
                                          );
                                        } finally {
                                          if (mounted) setState(() => _isLoading = false);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: _isLoading 
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Start',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDiamondLogo() {
    return SizedBox(
      width: 140,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/log_gauche.png',
            fit: BoxFit.cover,
            width: 140,
            height: 160,
          ),
        ],
      ),
    );
  }

  Widget buildShieldLogo() {
    return SizedBox(
      width: 180,
      height: 182,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/far_logo.png',
            fit: BoxFit.cover,
            width: 180,
            height: 182,
          ),
        ],
      ),
    );
  }
}