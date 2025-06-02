import 'package:cible_militaire/Services/authentificationService.dart';
import 'package:cible_militaire/Services/user_session.dart';
import 'package:cible_militaire/model/player.dart';
import 'package:cible_militaire/view/routes.dart';
import 'package:cible_militaire/view/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaneSelectionMilitaryScreen extends StatefulWidget {
  const LaneSelectionMilitaryScreen({super.key});

  @override
  State<LaneSelectionMilitaryScreen> createState() => _LaneSelectionMilitaryScreenState();
}

class _LaneSelectionMilitaryScreenState extends State<LaneSelectionMilitaryScreen> {
  int selectedLane = 1;
  String? selectedEmplacement = "1";
  String selectedRange = '100m';
  String selectedWeapon = 'AK-47';
  int selectedCoups = 10;
  bool isUpdating = false; // Pour gérer l'état de chargement

  final Map<String, List<String>> weaponOptions = {
    '100m': ['AK-47', 'AK-102', 'M16 A1', 'M16 A2', 'SAR-21'],
    '50m': ['Pistolet PA TT 33', 'Pistolet PA GP 35', 'MP5'],
  };

  final Map<String, String> weaponImages = {
    'AK-47': 'assets/weapons/AK-47.png',
    'AK-102': 'assets/weapons/AK-102.png',
    'M16 A1': 'assets/weapons/M16.png',
    'M16 A2': 'assets/weapons/M16.png',
    'SAR-21': 'assets/weapons/SAR-21.png',
    'Pistolet PA TT 33': 'assets/weapons/TT33.png',
    'Pistolet PA GP 35': 'assets/weapons/GP35.png',
    'MP5': 'assets/weapons/MP5.png',
  };

  final Map<String, String> weaponCoups = {
    'AK-47': '10',
    'AK-102': '10',
    'M16 A1': '10',
    'M16 A2': '10',
    'SAR-21': '10',
    'Pistolet PA TT 33': '8',
    'Pistolet PA GP 35': '8',
    'MP5': '15',
  };

  // Fonction pour mettre à jour les données dans Firestore
  Future<void> _updatePlayerData() async {
    setState(() {
      isUpdating = true;
    });

    try {
      // Récupérer l'utilisateur connecté
     final userSession = Provider.of<UserSession>(context, listen: false);
      final currentPlayer = userSession.currentUser;
      // Convertir selectedEmplacement en int
      int emplacementValue = int.tryParse(selectedEmplacement ?? "1") ?? 1;
      
      // Extraire la valeur numérique de la portée (100m -> 100)
      int porteeValue = int.tryParse(selectedRange.replaceAll('m', '')) ?? 100;

      // Mettre à jour l'emplacement
      bool emplacementUpdated = await AuthService.updatePlayerLocation(
        currentPlayer!.nom,
        currentPlayer.prenom,
        emplacementValue,
      );

      // Mettre à jour l'arme et la portée
      bool weaponUpdated = await AuthService.updatePlayerWeapon(
        currentPlayer.nom,
        currentPlayer.prenom,
        selectedWeapon,
        porteeValue,
      );

      if (emplacementUpdated && weaponUpdated) {
        print("✅ Données mises à jour avec succès:");
        print("   - Emplacement: $emplacementValue");
        print("   - Arme: $selectedWeapon");
        print("   - Portée: $porteeValue");
        
        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sélection enregistrée avec succès!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        // Naviguer vers l'écran suivant
        final selectedCoupsStr = weaponCoups[selectedWeapon] as String;
        final selectedCoups = int.tryParse(selectedCoupsStr) ?? 0;
        
        if (mounted) {
          Navigator.pushNamed(
            context, 
            AppRoutes.targetSelection,
            arguments: selectedCoups,
          );
        }
      } else {
        throw Exception("Échec de la mise à jour des données");
      }
        } catch (e) {
      print("❌ Erreur lors de la mise à jour: $e");
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          // Fond camouflage
          Positioned.fill(
            child: Image.asset(
              'assets/2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Interface principale
          Column(
            children: [
              const NavBar(),
              
              // Conteneur principal avec dimensions calculées
              Container(
                height: isLandscape ? screenSize.height * 0.74 : null,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Center(
                  child: Container(
                    width: isLandscape ? 460 : 400,
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(
                      maxHeight: isLandscape ? screenSize.height * 0.72 : screenSize.height * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.3), 
                                width: 1),
                            ),
                          ),
                          child: const Text(
                            'SÉLECTIONNER UNE LIGNE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        // Contenu compact
                        const SizedBox(height: 12),
                        _buildSectionTitle('Sélectionner l\'emplacement de tir'),
                        _buildEmplacementDropdown(),
                        
                        const SizedBox(height: 8),
                        _buildSectionTitle('Sélectionner la portée'),
                        _buildRangeDropdown(),
                        
                        const SizedBox(height: 8),
                        _buildSectionTitle('Sélectionner l\'arme'),
                        _buildWeaponDropdown(),
                        
                        // Bouton en bas
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: isUpdating ? null : _updatePlayerData, // Désactivé pendant la mise à jour
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isUpdating 
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.amber.withOpacity(0.8),
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: Colors.white.withOpacity(0.5)),
                              ),
                              elevation: 5,
                            ),
                            child: isUpdating
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'SAUVEGARDE...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_box, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'SÉLECTIONNER',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildEmplacementDropdown() {
    List<String> emplacements = List.generate(10, (index) => (index + 1).toString());
    
    return StyledDropdown(
      items: emplacements,
      hintText: 'Choisir un emplacement',
      value: selectedEmplacement,
      onChanged: (value) {
        setState(() {
          selectedEmplacement = value;
        });
      },
    );
  }
  
  Widget _buildRangeDropdown() {
    return StyledDropdown(
      items: ['100m', '50m'],
      hintText: 'Choisir une portée',
      value: selectedRange,
      onChanged: (value) {
        setState(() {
          selectedRange = value!;
          selectedWeapon = weaponOptions[selectedRange]![0];
        });
      },
    );
  }
  
  Widget _buildWeaponDropdown() {
    return StyledDropdown(
      items: weaponOptions[selectedRange]!,
      hintText: 'Choisir une arme',
      value: selectedWeapon,
      showImages: true,
      imageMap: weaponImages,
      onChanged: (value) {
        setState(() {
          selectedWeapon = value!;
        });
      },
    );
  }
}

class StyledDropdown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final String? value;
  final bool showImages;
  final Map<String, String>? imageMap;

  const StyledDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.value,
    this.showImages = false,
    this.imageMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Theme(
        data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
            thickness: WidgetStateProperty.all(4.0),
            thumbColor: WidgetStateProperty.all(Colors.white.withOpacity(0.5)),
            radius: const Radius.circular(10),
            thumbVisibility: WidgetStateProperty.all(true),
            mainAxisMargin: 2.0,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              hintText,
              style: const TextStyle(color: Colors.white70),
            ),
            dropdownColor: Colors.black87,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
            style: const TextStyle(color: Colors.white),
            menuMaxHeight: 180,
            isExpanded: true,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: showImages && imageMap != null && imageMap!.containsKey(value)
                    ? Row(
                        children: [
                          SizedBox(
                            width: 36,
                            height: 24,
                            child: Image.asset(
                              imageMap![value]!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(child: Text(value)),
                        ],
                      )
                    : Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}