import 'package:cible_militaire/view/pages/loginTabletteScreen.dart';
import 'package:cible_militaire/view/pages/selectArme.dart';
import 'package:cible_militaire/view/pages/targetSelectionPage.dart';
import 'package:cible_militaire/view/pages/training_start.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/Login';
  static const String laneselection = '/LaneSelectionPage';
  static const String targetselection = '/TargetSelectionPage';
  static const String trainingSession = '/TrainingSessionPage'; 

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => LoginTabletMilitaryScreen());
      case laneselection:
        return MaterialPageRoute(builder: (_) => LaneSelectionMilitaryScreen());
      case targetselection:
        return MaterialPageRoute(builder: (_) => TrainingModePage());
      case trainingSession:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TrainingSessionPage(
            selectedMode: args['selectedMode'],
            selectedTarget: args['selectedTarget'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page non trouvée : ${settings.name}')),
          ),
        );
    }
  }
}