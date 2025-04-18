import 'package:cible_militaire/model/shot.dart';
import 'package:flutter/material.dart';
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
    super.key,
    required this.selectedMode,
    required this.selectedTarget,
    required this.shots,
    required this.maxSeries,
    required this.totalScore,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final seriesData = _generateSeriesData();
    
    return Scaffold(
      body: Stack(
        children: [
          // Fond camouflage - SVG
          SvgPicture.asset(
            '../assets/5.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          Column(
            children: [
              // En-tête
              NavBar(),
              
              // Contenu principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Résultats de la session',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                          _buildSessionInfoCard(context),
                        ],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Résumé des performances
                      _buildPerformanceSummary(),
                      
                      SizedBox(height: 24),
                      
                      // Résultats par série
                      Expanded(
                        child: _buildSeriesResults(seriesData, context),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Boutons d'action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context); // Retour à la page précédente
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text('Retour'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.withOpacity(0.7),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navigation vers une nouvelle session
                              Navigator.pop(context);
                              // Ici, vous pourriez appeler la fonction _resetSession du parent
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Nouvelle Session'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.7),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildSessionInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mode_standby, size: 14, color: Colors.white70),
              SizedBox(width: 4),
              Text(
                selectedMode,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.track_changes, size: 14, color: Colors.white70),
              SizedBox(width: 4),
              Text(
                selectedTarget['name'],
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.blueGrey.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard(
              'Score Total',
              totalScore.toStringAsFixed(1),
              Icons.leaderboard,
              Colors.amber,
            ),
            _buildVerticalDivider(),
            _buildStatCard(
              'Précision',
              '${accuracy.toStringAsFixed(1)}%',
              Icons.precision_manufacturing,
              Colors.lightBlue,
            ),
            _buildVerticalDivider(),
            _buildStatCard(
              'Tirs',
              '${shots.length}',
              Icons.track_changes,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color accentColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
          ),
          child: Icon(
            icon,
            color: accentColor,
            size: 32,
          ),
        ),
        SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesResults(List<Map<String, dynamic>> seriesData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Résultats par série',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Text(
                '${seriesData.length} séries',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: seriesData.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = seriesData[index];
              final seriesScore = data['score'] as double;
              final accuracy = data['accuracy'] as double;
              final shotCount = data['shots'] as int;
              
              // Déterminer la couleur basée sur la précision
              Color accuracyColor;
              if (accuracy >= 90) {
                accuracyColor = Colors.green;
              } else if (accuracy >= 70) {
                accuracyColor = Colors.lightGreen;
              } else if (accuracy >= 50) {
                accuracyColor = Colors.amber;
              } else if (accuracy >= 30) {
                accuracyColor = Colors.orange;
              } else {
                accuracyColor = Colors.red;
              }
              
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.blueGrey.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey.withOpacity(0.7),
                    child: Text(
                      '${data['series']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'Série ${data['series']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: accuracy / 100,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(accuracyColor),
                      ),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Score: ${seriesScore.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${accuracy.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: accuracyColor,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDetailStat('Tirs', '$shotCount', Icons.track_changes),
                              _buildDetailStat('Moy. points', (seriesScore / shotCount).toStringAsFixed(1), Icons.stars),
                              _buildDetailStat('Précision', '${accuracy.toStringAsFixed(1)}%', Icons.precision_manufacturing),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildTargetVisualization(data['series'] as int),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetVisualization(int seriesNum) {
    // Filtrer les tirs de cette série
    final seriesShots = shots.where((shot) => shot.series == seriesNum).toList();
    
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cible miniature
          SvgPicture.string(
            selectedTarget['svg'],
            width: 180,
            height: 180,
          ),
          
          // Tirs de cette série
          ...seriesShots.map((shot) => Positioned(
            left: (0 / 400 * 180) - 3 + 90 - 10,  // Ajustement pour le centre et la taille
            top: (0 / 400 * 180) - 3 + 90 - 10,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _getShotColor(shot.score),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Color _getShotColor(double score) {
    if (score >= 9) return Colors.red;
    if (score >= 7) return Colors.orange;
    if (score >= 5) return Colors.yellow;
    if (score >= 3) return Colors.green;
    return Colors.blue;
  }

  List<Map<String, dynamic>> _generateSeriesData() {
    return List.generate(maxSeries, (index) => index + 1)
        .map((series) {
          final seriesShots = shots.where((shot) => shot.series == series).toList();
          if (seriesShots.isEmpty) {
            return {'series': series, 'score': 0.0, 'accuracy': 0.0, 'shots': 0};
          }
          
          final seriesScore = seriesShots.fold<double>(0, (sum, shot) => sum + shot.score);
          final seriesAccuracy = (seriesShots.where((shot) => shot.score >= 7).length / seriesShots.length) * 100;
          
          return {
            'series': series, 
            'score': seriesScore, 
            'accuracy': seriesAccuracy, 
            'shots': seriesShots.length
          };
        }).toList();
  }
}
