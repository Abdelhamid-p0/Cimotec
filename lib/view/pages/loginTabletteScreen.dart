import 'package:cible_militaire/Services/authentificationService.dart';
import 'package:cible_militaire/Services/user_session.dart';
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
  final TextEditingController _BdeNumlisteController = TextEditingController(text: "0");

  // Utilisation de const pour éviter les reconstructions inutiles
  static const List<String> promotion_list = ['INVITÉ(E)','1ère ANNÉE', '2ème ANNÉE', '3ème ANNÉE', 'CYCLE SPÉCIAL','4ème ANNÉE'];
  static const List<String> brigade_list = ['N°1', 'N°2', 'N°3', 'N°4','N°5', 'N°6', 'N°7', 'N°8','N°9', 'N°10', 'N°11', 'N°12'];
  
  String promotion = "PROMOTION";
  String brigade = "BRIGADE";
  static const String _hintListe = 'Vous êtes en mode invitée';
  bool isCreateMode = false;
  bool isInvite = false;
  bool _isLoading = false;

  // Variables pour optimiser les rebuilds
  late final ValueNotifier<bool> _createModeNotifier;
  late final ValueNotifier<bool> _inviteNotifier;
  
  @override
  void initState() {
    super.initState();
    _createModeNotifier = ValueNotifier<bool>(isCreateMode);
    _inviteNotifier = ValueNotifier<bool>(isInvite);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _NumlisteController.dispose();
    _BdeNumlisteController.dispose();
    _createModeNotifier.dispose();
    _inviteNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleAuthentication() async {
    // Vérification des champs obligatoires
    if (_nomController.text.trim().isEmpty || _prenomController.text.trim().isEmpty) {
      _showErrorSnackBar("Le nom et le prénom sont obligatoires");
      return;
    }
    
    // En mode création, vérifier les champs additionnels
    if (isCreateMode) {
      if (promotion == "PROMOTION" || brigade == "BRIGADE") {
        _showErrorSnackBar("Veuillez sélectionner une promotion et une brigade");
        return;
      }
      
      if (!isInvite && _NumlisteController.text.trim().isEmpty) {
        _showErrorSnackBar("Le numéro de liste est obligatoire");
        return;
      }
    } else if (_NumlisteController.text.trim().isEmpty) {
      _showErrorSnackBar("Le numéro de liste est obligatoire");
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      if (isCreateMode) {
        AuthResult isRegistered = await AuthService.registeringAuthentificationService(
          _nomController,
          _prenomController,
          _NumlisteController,
          promotion,
          brigade,
        );
        
        if (isRegistered.success) {
          await _loginUser();
        } else {
          _showErrorSnackBar("Erreur lors de l'inscription");
        }
      } else {
        AuthResult isAuthenticated = await AuthService.checkingAuthentificationService(
          _nomController.text,
          _prenomController.text,
          _NumlisteController.text,
        );
        
        if (isAuthenticated.success) {
          await _loginUser();
        } else {
          _showErrorSnackBar("Authentification échouée - vérifiez vos informations");
        }
      }
    } catch (e) {
      debugPrint("Erreur: $e");
      _showErrorSnackBar("Une erreur est survenue: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _loginUser() async {
    final players = await AuthService.readPlayerData();
    try {
      final loggedInUser = players.firstWhere(
        (p) => p.nom.toLowerCase() == _nomController.text.trim().toLowerCase() && 
               p.prenom.toLowerCase() == _prenomController.text.trim().toLowerCase()
      );
      
      final userSession = Provider.of<UserSession>(context, listen: false);
      userSession.login(loggedInUser);
      
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.laneSelection);
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération de l'utilisateur: $e");
      _showErrorSnackBar("Utilisateur non trouvé");
    }
  }

  void _toggleCreateMode(bool createMode) {
    setState(() {
      isCreateMode = createMode;
      _createModeNotifier.value = createMode;
    });
  }

  void _onPromotionChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        promotion = newValue;
        isInvite = newValue == "INVITÉ(E)";
        _inviteNotifier.value = isInvite;
      });
    }
  }

  void _onBrigadeChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        brigade = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fond camouflage
          Positioned.fill(
            child: Image.asset(
              'assets/1.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Interface principale
          SafeArea(
            child: Row(
              children: [
                // Panneau gauche optimisé
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black.withOpacity(0.15),
                    child: _buildLeftPanel(),
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
                    child: _buildRightPanel(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Méthodes pour construire les panneaux
  Widget _buildLeftPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      Image.asset(
                        'assets/log_gauche.png',
                        fit: BoxFit.cover,
                        width: 140,
                        height: 160,
                        cacheWidth: 140,
                        cacheHeight: 160,
                      ),
                      Container(
                        width: 1,
                        height: 120,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 22),
                      Image.asset(
                        'assets/far_logo.png',
                        fit: BoxFit.cover,
                        width: 180,
                        height: 182,
                        cacheWidth: 180,
                        cacheHeight: 182,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
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
    );
  }

  Widget _buildRightPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
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
                        onTap: () => _toggleCreateMode(false),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                            color: isCreateMode ? Colors.grey : Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _toggleCreateMode(true),
                        child: Text(
                          ' | Create',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                            color: isCreateMode ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Champs nom et prénom
                  Row(
                    children: [
                      Expanded(
                        child: inputField(_nomController, "Nom"),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: inputField(_prenomController, "Prenom"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdowns en mode création
                  if (isCreateMode) ...[
                    Row(
                      children: [
                        Expanded(
                          child: StyledDropdown( 
                            items: promotion_list,
                            hintText: promotion,
                            onChanged: _onPromotionChanged,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StyledDropdown( 
                            items: brigade_list,
                            hintText: brigade,
                            onChanged: _onBrigadeChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Champ numéro de liste
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _NumlisteController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: isInvite ? _hintListe : "N° Liste",
                        hintStyle: const TextStyle(color: Colors.white70),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      readOnly: isInvite,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Bouton Start
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuthentication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading 
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}