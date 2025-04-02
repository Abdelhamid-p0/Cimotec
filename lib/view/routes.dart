import 'package:cible_militaire/view/pages/loginTabletteScreen.dart';
import 'package:cible_militaire/view/pages/selectArme.dart';
import 'package:cible_militaire/view/pages/targetSelectionPage.dart';
import 'package:cible_militaire/view/pages/training_start.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String laneSelection = '/lane-selection';
  static const String targetSelection = '/target-selection';
  static const String trainingSession = '/training-session'; 

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginTabletMilitaryScreen());
      case laneSelection:
        return MaterialPageRoute(builder: (_) => LaneSelectionMilitaryScreen());
      case targetSelection:
        final args = settings.arguments;
        if (args is! int) {
          return _errorRoute('Argument must be an integer');
        }
        return MaterialPageRoute(
          builder: (_) => TrainingModePage(selectedCoups: args),
        );
      case trainingSession:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || 
            args['selectedMode'] == null || 
            args['selectedTarget'] == null) {
          return _errorRoute('Invalid arguments for training session');
        }
        return MaterialPageRoute(
          builder: (_) => TrainingSessionPage(
            selectedMode: args['selectedMode'],
            selectedTarget: args['selectedTarget'],
          ),
        );
      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}