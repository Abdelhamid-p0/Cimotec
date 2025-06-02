import 'package:cible_militaire/Services/user_session.dart';
import 'package:cible_militaire/firebase_options.dart';
import 'package:cible_militaire/view/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Éviter la double initialisation - une seule fois suffit
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration de l'interface système
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialisation Firebase avec option de chargement différé
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // name: 'military-target', // Décommentez si vous avez plusieurs instances Firebase
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSession()),
        // Ajoutez d'autres providers ici au besoin
      ],
      child: const MilitaryTargetApp(),
    ),
  );
}

class MilitaryTargetApp extends StatelessWidget {
  const MilitaryTargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cible Militaire',
      theme: _buildMilitaryTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      navigatorKey: NavigationService.navigatorKey,
      // Ajout pour améliorer les performances
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: _ScrollBehaviorModified(),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildMilitaryTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50), // Vert militaire
        brightness: Brightness.light,
        primary: const Color(0xFF4CAF50),
        secondary: const Color(0xFF8BC34A),
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4CAF50),
        elevation: 0,
      ),
      // Optimisation des animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

// Optimisation du défilement
class _ScrollBehaviorModified extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// Service de navigation globale
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }
  
  static void goBack() {
    navigatorKey.currentState!.pop();
  }
}