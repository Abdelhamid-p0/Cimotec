import 'package:flutter/material.dart';

class ZoomableTrainingInfo extends StatelessWidget {
  final dynamic _timeRemaining;
  final dynamic _maxShots;
  final dynamic _maxSeries;
  
  const ZoomableTrainingInfo({
    super.key,
    required dynamic timeRemaining,
    required dynamic maxShots,
    required dynamic maxSeries,
  }) : _timeRemaining = timeRemaining,
       _maxShots = maxShots,
       _maxSeries = maxSeries;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true, // Activation du déplacement
      scaleEnabled: true, // Activation du zoom/pinch
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.5, // Échelle minimale
      maxScale: 4.0, // Échelle maximale
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoItem(Icons.timer, "Temps d'entrainement: $_timeRemaining sec"),
            const SizedBox(width: 16),
            _buildInfoItem(Icons.golf_course, "Nombre de tirs: $_maxShots"),
            const SizedBox(width: 16),
            _buildInfoItem(Icons.repeat, "Séries: $_maxSeries"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.grey[800]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}