import 'package:cible_militaire/controller/user_session.dart';
import 'package:cible_militaire/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // Initialisation des bindings et orientation
  WidgetsFlutterBinding.ensureInitialized();

  // 👉 Cacher la barre du haut et la barre de navigation
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // 👉 Forcer en mode paysage
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

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
      // Pour la navigation globale
      navigatorKey: NavigationService.navigatorKey,
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
      // Autres customizations...
    );
  }
}

// Service de navigation globale
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Future<dynamic> navigateTo(String routeName, {arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }
  
  static void goBack() {
    navigatorKey.currentState!.pop();
  }
}