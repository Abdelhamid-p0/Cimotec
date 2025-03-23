import 'package:cible_militaire/view/routes.dart';
import 'package:cible_militaire/view/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Theme(
        data: Theme.of(context).copyWith(
          // Customisation du scrollbar
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
            menuMaxHeight: 200, // Limite la hauteur de la liste déroulante
            isExpanded: true,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: showImages && imageMap != null && imageMap!.containsKey(value)
                    ? Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 30,
                            child: Image.asset(
                              imageMap![value]!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(value),
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

class LaneSelectionMilitaryScreen extends StatefulWidget {
  const LaneSelectionMilitaryScreen({super.key});

  @override
  State<LaneSelectionMilitaryScreen> createState() => _LaneSelectionMilitaryScreenState();
}

class _LaneSelectionMilitaryScreenState extends State<LaneSelectionMilitaryScreen> {
  int selectedLane = 1;
  String? selectedEmplacement = "1";
  String selectedRange = '100m';
  String selectedWeapon = 'AK-47'; // Default weapon for 100m

  // Define weapon options based on range
  final Map<String, List<String>> weaponOptions = {
    '100m': ['AK-47', 'AK-102', 'M16 A1', 'M16 A2', 'SAR-21'],
    '50m': ['Pistolet PA TT 33', 'Pistolet PA GP 35', 'MP5'],
  };

  // Map pour les images d'armes - Assurez-vous que ces fichiers existent dans vos assets
  final Map<String, String> weaponImages = {
    'AK-47': '../assets/weapons/AK-47.png',
    'AK-102': '../assets/weapons/AK-102.png',
    'M16 A1': '../assets/weapons/M16.png',
    'M16 A2': '../assets/weapons/M16.png',
    'SAR-21': '../assets/weapons/SAR-21.png',
    'Pistolet PA TT 33': '../assets/weapons/TT33.png',
    'Pistolet PA GP 35': '../assets/weapons/GP35.png',
    'MP5': '../assets/weapons/MP5.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond camouflage - SVG
          SvgPicture.asset(
            '../assets/2.svg', // Assurez-vous que ce fichier existe dans vos assets
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Interface principale
          Column(
            children: [
              // En-tête avec logos et titre
              NavBar(),
              
              // Contenu principal - Sélection de voie
              Expanded(
                child: Center(
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8.0),
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
                        // Titre avec style militaire
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                            ),
                          ),
                          child: const Text(
                            'SELECT LANE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
    
                        
                        const SizedBox(height: 24),
                        
                        // Sélection de l'emplacement de tir
                        _buildSectionTitle('Sélectionner l\'emplacement de tir'),
                        _buildEmplacementDropdown(),
                        
                        const SizedBox(height: 16),
                        
                        // Sélection de la portée
                        _buildSectionTitle('Sélectionner la portée'),
                        _buildRangeDropdown(),
                        
                        const SizedBox(height: 16),
                        
                        // Sélection de l'arme
                        _buildSectionTitle('Sélectionner l\'arme'),
                        _buildWeaponDropdown(),
                        
                        const SizedBox(height: 24),
                        
                        // Bouton de confirmation
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.targetselection);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.withOpacity(0.8),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: Colors.white.withOpacity(0.5)),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_box, size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                'SELECT',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
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

  Widget _buildLaneItem(String title, int laneNumber) {
    final bool isSelected = selectedLane == laneNumber;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLane = laneNumber;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey.withOpacity(0.5) : Colors.black.withOpacity(0.2),
          border: Border.all(
            color: isSelected ? Colors.lightBlueAccent.withOpacity(0.7) : Colors.white.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
            if (isSelected)
              const Icon(Icons.chevron_right, color: Colors.lightBlueAccent, size: 18),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
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
          // Update selected weapon to first weapon in the new range category
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