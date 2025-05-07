import 'package:flutter/material.dart';
import 'package:cible_militaire/model/shot.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cible_militaire/view/widgets/nav_bar.dart';

class TrainingStatsPage extends StatelessWidget {
  final String selectedMode;
  final Map<String, dynamic> selectedTarget;
  final List<Shot> shots;
  final int maxSeries;
  final double totalScore;
  final double accuracy;

  const TrainingStatsPage({
    Key? key,
    required this.selectedMode,
    required this.selectedTarget,
    required this.shots,
    required this.maxSeries,
    required this.totalScore,
    required this.accuracy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headShots = shots.where((shot) => shot.section == "head").length;
    final torsoShots = shots.where((shot) => shot.section == "torso").length;
    final extremityShots = shots.where((shot) => shot.section == "extremity").length;
    final totalShots = shots.length;
    final averageScore = totalShots > 0 ? totalScore / totalShots : 0.0;

    return Scaffold(
      body: Stack(
        children: [
          // Fond d'écran SVG
          SvgPicture.asset(
            'assets/4.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          Column(
            children: [
              // Barre de navigation
              const NavBar(),
              
              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // En-tête avec opacité
                      _buildTransparentCard(
                        child: Column(
                          children: [
                            Text(
                              'Résumé de la Session',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(color: Colors.white.withOpacity(0.5)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mode: $selectedMode',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Cible: ${selectedTarget['name'] ?? 'Non spécifiée'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      DateFormat('HH:mm').format(DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Statistiques principales avec opacité
                      _buildTransparentCard(
                        child: Column(
                          children: [
                            Text(
                              'Statistiques Principales',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatCircle('Score Total', totalScore.toStringAsFixed(1), Colors.blue),
                                _buildStatCircle('Précision', '${accuracy.toStringAsFixed(1)}%', Colors.green),
                                _buildStatCircle('Moyenne', averageScore.toStringAsFixed(1), Colors.orange),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Répartition des Tirs',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSectionStat('Tête', headShots, totalShots, Colors.green),
                                _buildSectionStat('Ventre', torsoShots, totalShots, Colors.blue),
                                _buildSectionStat('Extrémité', extremityShots, totalShots, Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Détails par série avec opacité
                      _buildTransparentCard(
                        child: Column(
                          children: [
                            Text(
                              'Détails par Série',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Série',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Tirs',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Score',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Précision',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.white.withOpacity(0.5)),
                            for (int i = 1; i <= maxSeries; i++)
                              _buildSeriesRow(i),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Détails des tirs avec opacité
                      _buildTransparentCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Détails des Tirs',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: shots.length,
                                itemBuilder: (context, index) {
                                  final shot = shots[index];
                                  return ListTile(
                                    leading: _getSectionIcon(shot.section),
                                    title: Text(
                                      'Tir ${index + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Série ${shot.series} - ${DateFormat('HH:mm:ss').format(shot.timestamp)}',
                                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    ),
                                    trailing: Text(
                                      '${shot.score.toStringAsFixed(1)} pts',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Bouton de partage
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implémenter le partage
                          },
                          icon: const Icon(Icons.share, size: 20),
                          label: const Text(
                            'PARTAGER LES RÉSULTATS',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildTransparentCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5), // Opacité ajustable ici
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildStatCircle(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionStat(String label, int count, int total, Color color) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '(${percentage.toStringAsFixed(1)}%)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesRow(int seriesNumber) {
    final seriesShots = shots.where((shot) => shot.series == seriesNumber).toList();
    final seriesScore = seriesShots.fold(0.0, (sum, shot) => sum + shot.score);
    final goodShots = seriesShots.where((shot) => shot.section == "head" || shot.section == "torso").length;
    final accuracy = seriesShots.isNotEmpty ? (goodShots / seriesShots.length * 100) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Série $seriesNumber',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              '${seriesShots.length}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              seriesScore.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              '${accuracy.toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSectionIcon(String section) {
    switch (section) {
      case "head":
        return Icon(Icons.circle, color: Colors.green);
      case "torso":
        return Icon(Icons.circle, color: Colors.blue);
      case "extremity":
        return Icon(Icons.circle, color: Colors.orange);
      default:
        return Icon(Icons.circle, color: Colors.grey);
    }
  }
}