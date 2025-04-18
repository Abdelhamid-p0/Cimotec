import 'package:cible_militaire/model/player.dart';
import 'package:flutter/material.dart';

class UserSession with ChangeNotifier {
  Player? currentUser;

  Player? get mycurrentUser => currentUser;

  void login(Player user) {
    currentUser = user;
    notifyListeners(); // Notifie les écouteurs (Provider)
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  bool get isLoggedIn => currentUser != null;
}