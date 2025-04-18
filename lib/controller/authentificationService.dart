import 'dart:convert';
import 'dart:io';
import 'package:cible_militaire/model/player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class AuthService {
  static const String _fileName = '../utilisateurs.json';
  static const String _storageKey = 'utilisateurs_data';

  // Obtenir le fichier JSON (pour Android)
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$_fileName';
    return File(path);
  }

  // Lire les données des joueurs
   static  Future<List<Player>> readPlayerData() async {
    try {
      if (kIsWeb) {
        // Utiliser SharedPreferences pour le web (débogage)
        final prefs = await SharedPreferences.getInstance();
        final String? jsonData = prefs.getString(_storageKey);
        
        if (jsonData == null || jsonData.isEmpty) {
          print("null / empty");
          return [];
        }
        
        final List<dynamic> jsonResponse = jsonDecode(jsonData);
        return jsonResponse.map((p) => Player.fromJson(p)).toList();
      } else {
        // Utiliser File pour Android (production)
        final file = await _getFile();
        
        if (!file.existsSync()) {
          // Créer un fichier vide avec un tableau JSON vide
          await file.create(recursive: true);
          await file.writeAsString('[]');
          return [];
        }
        
        final String contents = await file.readAsString();
        if (contents.isEmpty) {
          await file.writeAsString('[]');
          return [];
        }
        
        final List<dynamic> jsonResponse = jsonDecode(contents);
        return jsonResponse.map((p) => Player.fromJson(p)).toList();
      }
    } catch (e) {
      print("Erreur lors de la lecture des données: $e");
      return [];
    }
  }

  // Sauvegarder les données des joueurs
  static Future<bool> _savePlayerData(List<Player> players) async {
    try {
      final List<Map<String, dynamic>> jsonData = players.map((p) => p.toJson()).toList();
      final String jsonString = jsonEncode(jsonData);
      
      if (kIsWeb) {
        // Utiliser SharedPreferences pour le web (débogage)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, jsonString);
      } else {
        // Utiliser File pour Android (production)
        final file = await _getFile();
        await file.writeAsString(jsonString, flush: true);
      }
      
      return true;
    } catch (e) {
      print("Erreur lors de la sauvegarde des données: $e");
      return false;
    }
  }

  // Vérification de l'authentification
  static Future<bool> checkingAuthentificationService(
    TextEditingController nomController,
    TextEditingController prenomController,
    TextEditingController numlisteController,
    TextEditingController bdeNumlisteController
  ) async {
    try {
      final players = await readPlayerData();
      
      print("Vérification d'authentification pour: ${nomController.text} ${prenomController.text}");
      print("Nombre d'utilisateurs chargés: ${players.length}");
      
      // Vérifier si l'utilisateur existe dans la liste
      bool userExists = players.any((player) =>
        player.nom == nomController.text &&
        player.prenom == prenomController.text &&
        player.numeroListe == numlisteController.text &&
        player.bdeNumeroListe == bdeNumlisteController.text
      );
      
      print("Utilisateur trouvé: $userExists");
      return userExists;
    } catch (e) {
      print("Erreur lors de l'authentification: $e");
      return false;
    }
  }

  // Enregistrement d'un nouvel utilisateur
  static Future<bool> registeringAuthentificationService(
    TextEditingController nomController,
    TextEditingController prenomController,
    TextEditingController numlisteController,
    TextEditingController bdeNumlisteController,
    String promotion,
    String brigade
  ) async {
    try {
      final players = await readPlayerData();

      // Vérifier si l'utilisateur existe déjà
      bool existe = players.any((player) =>
        player.nom == nomController.text &&
        player.prenom == prenomController.text
      );

      if (existe) {
        print("Utilisateur déjà enregistré !");
        return false;
      }

      // Créer le nouvel utilisateur
      Player nouveauJoueur = Player(
        nom: nomController.text,
        prenom: prenomController.text,
        promotion: promotion,
        brigade: brigade,
        numeroListe: numlisteController.text,
        bdeNumeroListe: bdeNumlisteController.text, resume: {}, historiques: {},
      );

      // Ajouter le nouvel utilisateur
      players.add(nouveauJoueur);

      // Sauvegarder les données
      bool saveSuccess = await _savePlayerData(players);
      
      if (saveSuccess) {
        print("Utilisateur enregistré avec succès !");
        return true;
      } else {
        print("Échec de l'enregistrement de l'utilisateur");
        return false;
      }
    } catch (e) {
      print("Erreur lors de l'enregistrement: $e");
      return false;
    }
  }
}