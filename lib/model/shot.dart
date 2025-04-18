class Shot {
  final String section; // "head", "torso" ou "extremity"
  final int series;
  final DateTime timestamp;

  Shot({
    required this.section,
    required this.series,
    required this.timestamp,
  });

  // Ajout d'un getter pour le score basé sur la section touchée
  double get score {
    switch (section) {
      case "head":
        return 10.0;
      case "torso":
        return 7.0;
      case "extremity":
        return 5.0;
      default:
        return 0.0;
    }
  }
}