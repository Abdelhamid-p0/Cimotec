import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cible_militaire/model/player.dart';
import 'package:cible_militaire/model/shot.dart';
import 'package:flutter/material.dart';

class AuthService {
  // Référence à la collection Firestore
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection = _firestore.collection('utilisateurs');
  
  // Lire les données des joueurs depuis Firestore
  static Future<List<Player>> readPlayerData() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      
      List<Player> players = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Document chargé: ${data['nom']} ${data['prenom']}, champs: ${data.keys.join(', ')}");
        
        // Utilise la nouvelle méthode fromJson qui gère tous les champs
        return Player.fromJson({
          'id': doc.id,
          ...data, // Spread operator pour inclure tous les champs
        });
      }).toList();
      
      print("Nombre d'utilisateurs chargés: ${players.length}");
      return players;
    } catch (e) {
      print("Erreur lors de la lecture des données Firestore: $e");
      return [];
    }
  }

  // ✨ MÉTHODE: Vérifier si quelqu'un est déjà connecté
  static Future<Player?> checkIfAnyoneOnline() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .where('EnLigne', isEqualTo: true)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        return Player.fromJson({
          'id': doc.id,
          ...data,
        });
      }
      
      return null;
    } catch (e) {
      print("Erreur lors de la vérification des utilisateurs en ligne: $e");
      return null;
    }
  }

  // ✨ MÉTHODE CORRIGÉE: Connexion avec déconnexion forcée des autres
  static Future<AuthResult> checkingAuthentificationService(
    String nom,
    String prenom,
    String numliste,
  ) async {
    try {
      // Conversion et nettoyage
      final cleanNom = nom.trim().toLowerCase();
      final cleanPrenom = prenom.trim().toLowerCase();
      final cleanNumListe = numliste.trim();

      // Génération de l'ID de document (format cohérent)
      String documentId = "$cleanPrenom $cleanNom";
      print("Recherche par ID de document: '$documentId'");

      // Récupération du document
      DocumentSnapshot userDoc = await _usersCollection.doc(documentId).get();

      if (!userDoc.exists) {
        print("Aucun document trouvé avec l'ID: $documentId");
        return AuthResult(success: false, message: "Utilisateur non trouvé");
      }

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      print("Document trouvé: ${data['prenom']} ${data['nom']}");

      // Vérification du numéro de liste
      String docNumeroListe = (data['numeroListe'] ?? '').toString();
      if (docNumeroListe != cleanNumListe) {
        print("Numéro de liste incorrect. Attendu: $docNumeroListe, Reçu: $cleanNumListe");
        return AuthResult(success: false, message: "Numéro de liste incorrect");
      }

      // ✨ NOUVEAU COMPORTEMENT: Déconnecter TOUS les autres utilisateurs
      print("Déconnexion forcée de tous les utilisateurs...");
      
      // Récupérer tous les utilisateurs en ligne
      QuerySnapshot allOnlineUsers = await _usersCollection
          .where('EnLigne', isEqualTo: true)
          .get();
      
      WriteBatch batch = _firestore.batch();
      
      // Déconnecter tous les utilisateurs en ligne
      for (DocumentSnapshot doc in allOnlineUsers.docs) {
        batch.update(doc.reference, {'EnLigne': false});
        print("Déconnexion forcée de: ${doc.id}");
      }
      
      // Connecter le nouvel utilisateur
      batch.update(_usersCollection.doc(documentId), {'EnLigne': true});
      
      // Exécuter toutes les opérations en une seule transaction
      await batch.commit();

      print("Tous les autres utilisateurs déconnectés et $documentId connecté!");
      return AuthResult(success: true, message: "Connexion réussie - session unique établie");

    } catch (e) {
      print("Erreur lors de l'authentification: $e");
      return AuthResult(success: false, message: "Erreur de connexion: $e");
    }
  }

  // ✨ MÉTHODE CORRIGÉE: Enregistrement avec déconnexion forcée des autres
  static Future<AuthResult> registeringAuthentificationService(
    TextEditingController nomController,
    TextEditingController prenomController,
    TextEditingController numlisteController,
    String promotion,
    String brigade
  ) async {
    try {
      // Rejeter si un champ est vide
      if (nomController.text.trim().isEmpty ||
          prenomController.text.trim().isEmpty ||
          numlisteController.text.trim().isEmpty) {
        print("Champs obligatoires manquants. Enregistrement refusé.");
        return AuthResult(success: false, message: "Tous les champs sont obligatoires");
      }

      // ✨ CORRECTION: Utiliser le même format d'ID que pour la connexion
      // Format: "prenom nom" (avec espace, en minuscules)
      String documentId = "${prenomController.text.trim().toLowerCase()} ${nomController.text.trim().toLowerCase()}";
      print("Création de l'utilisateur avec l'ID: $documentId");

      // Vérifier si l'utilisateur existe déjà
      DocumentSnapshot existingDoc = await _usersCollection.doc(documentId).get();
      if (existingDoc.exists) {
        print("Utilisateur déjà enregistré avec l'ID: $documentId");
        return AuthResult(success: false, message: "Cet utilisateur est déjà enregistré");
      }

      // ✨ DÉCONNEXION FORCÉE DE TOUS + ENREGISTREMENT + CONNEXION EN UNE TRANSACTION
      print("Déconnexion forcée de tous les utilisateurs avant enregistrement...");
      
      // Récupérer tous les utilisateurs en ligne
      QuerySnapshot allOnlineUsers = await _usersCollection
          .where('EnLigne', isEqualTo: true)
          .get();
      
      WriteBatch batch = _firestore.batch();
      
      // Déconnecter tous les utilisateurs en ligne
      for (DocumentSnapshot doc in allOnlineUsers.docs) {
        batch.update(doc.reference, {'EnLigne': false});
        print("Déconnexion forcée de: ${doc.id}");
      }
      
      // Créer le nouvel utilisateur avec TOUS les champs ET connecté
      Player newPlayer = Player(
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        promotion: promotion,
        brigade: brigade,
        numeroListe: numlisteController.text.trim(),
        parties: 0,
        points: 0,
        tete: 0,
        ventre: 0,
        extremite: 0,
        emplacement: 0,
        enligne: true,  // ✨ Connecté automatiquement après enregistrement
        portee: 0,
        arme: "",
      );

      // Ajouter la création du nouvel utilisateur au batch
      batch.set(_usersCollection.doc(documentId), newPlayer.toJson());
      
      // Exécuter toutes les opérations en une seule transaction
      await batch.commit();

      print("Tous les autres utilisateurs déconnectés et nouvel utilisateur $documentId créé et connecté!");
      return AuthResult(success: true, message: "Enregistrement et connexion réussis - session unique établie");
      
    } catch (e) {
      print("Erreur lors de l'enregistrement: $e");
      return AuthResult(success: false, message: "Erreur lors de l'enregistrement: $e");
    }
  }

  // ✨ MÉTHODE: Forcer la déconnexion de tous les utilisateurs
  static Future<bool> forceLogoutAll() async {
    try {
      QuerySnapshot onlineUsers = await _usersCollection
          .where('EnLigne', isEqualTo: true)
          .get();
      
      WriteBatch batch = _firestore.batch();
      
      for (DocumentSnapshot doc in onlineUsers.docs) {
        batch.update(doc.reference, {'EnLigne': false});
      }
      
      await batch.commit();
      
      print("Tous les utilisateurs ont été déconnectés");
      return true;
    } catch (e) {
      print("Erreur lors de la déconnexion forcée: $e");
      return false;
    }
  }

  // ✨ MÉTHODE CORRIGÉE: Déconnexion avec le bon format d'ID
  static Future<bool> logout(String nom, String prenom) async {
    try {
      // Format cohérent: "prenom nom" (avec espace, en minuscules)
      String documentId = "${prenom.trim().toLowerCase()} ${nom.trim().toLowerCase()}";
      
      await _usersCollection.doc(documentId).update({
        'EnLigne': false,
      });
      
      print("Déconnexion réussie pour: $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la déconnexion: $e");
      return false;
    }
  }

  // ✨ MÉTHODE CORRIGÉE: Mise à jour des statistiques avec le bon format d'ID
  static Future<bool> updatePlayerStats(
    Player currentPlayer,
    List<Shot> sessionShots
  ) async {
    try {
      // Format cohérent: "prenom nom" (avec espace, en minuscules)
      String documentId = "${currentPlayer.prenom.trim().toLowerCase()} ${currentPlayer.nom.trim().toLowerCase()}";
      print("Mise à jour des stats pour: $documentId");

      // Obtenir le document du joueur
      DocumentSnapshot playerDoc = await _usersCollection.doc(documentId).get();

      if (!playerDoc.exists) {
        print("Joueur non trouvé dans Firestore avec l'ID: $documentId");
        return false;
      }

      // Calculer les nouvelles statistiques
      final int newParties = currentPlayer.parties + 1;

      // Compter les tirs par section
      final int newTete = currentPlayer.tete + sessionShots.where((s) => s.section == "head").length;
      final int newVentre = currentPlayer.ventre + sessionShots.where((s) => s.section == "torso").length;
      final int newExtremite = currentPlayer.extremite + sessionShots.where((s) => s.section == "extremity").length;

      // Calculer le total des points
      final int sessionPoints = sessionShots.fold(0, (sum, shot) => sum + shot.score.toInt());
      final int newPoints = currentPlayer.points + sessionPoints;

      // Mettre à jour seulement les statistiques de jeu
      await _usersCollection.doc(documentId).update({
        'parties': newParties,
        'points': newPoints,
        'tete': newTete,
        'ventre': newVentre,
        'extremite': newExtremite,
      });

      print("Statistiques mises à jour pour le joueur avec ID: $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour des stats: $e");
      return false;
    }
  }


static Future<bool> updateTete(
    Player currentPlayer,
  ) async {
    try {
      // Format cohérent: "prenom nom" (avec espace, en minuscules)
      String documentId = "${currentPlayer.prenom.trim().toLowerCase()} ${currentPlayer.nom.trim().toLowerCase()}";
      print("Mise à jour des stats pour: $documentId");

      // Obtenir le document du joueur
      DocumentSnapshot playerDoc = await _usersCollection.doc(documentId).get();

      if (!playerDoc.exists) {
        print("Joueur non trouvé dans Firestore avec l'ID: $documentId");
        return false;
      }

            // Mettre à jour seulement les statistiques de jeu
     await _usersCollection.doc(documentId).update({
  'tete': FieldValue.increment(1),
  'points': FieldValue.increment(5),
});

      print("Statistiques mises à jour pour le joueur avec ID: $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour des stats: $e");
      return false;
    }
  }

static Future<bool> updateVentre(
    Player currentPlayer,
  ) async {
    try {
      // Format cohérent: "prenom nom" (avec espace, en minuscules)
      String documentId = "${currentPlayer.prenom.trim().toLowerCase()} ${currentPlayer.nom.trim().toLowerCase()}";
      print("Mise à jour des stats pour: $documentId");

      // Obtenir le document du joueur
      DocumentSnapshot playerDoc = await _usersCollection.doc(documentId).get();

      if (!playerDoc.exists) {
        print("Joueur non trouvé dans Firestore avec l'ID: $documentId");
        return false;
      }



      // Mettre à jour seulement les statistiques de jeu
     await _usersCollection.doc(documentId).update({
  'ventre': FieldValue.increment(1),
  'points': FieldValue.increment(3),
});


      print("Statistiques mises à jour pour le joueur avec ID: $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour des stats: $e");
      return false;
    }
  }

static Future<bool> updateExtr(
    Player currentPlayer,
  ) async {
    try {
      // Format cohérent: "prenom nom" (avec espace, en minuscules)
      String documentId = "${currentPlayer.prenom.trim().toLowerCase()} ${currentPlayer.nom.trim().toLowerCase()}";
      print("Mise à jour des stats pour: $documentId");

      // Obtenir le document du joueur
      DocumentSnapshot playerDoc = await _usersCollection.doc(documentId).get();

      if (!playerDoc.exists) {
        print("Joueur non trouvé dans Firestore avec l'ID: $documentId");
        return false;
      }

            // Mettre à jour seulement les statistiques de jeu
     await _usersCollection.doc(documentId).update({
  'extremite': FieldValue.increment(1),
  'points': FieldValue.increment(1),
});

      print("Statistiques mises à jour pour le joueur avec ID: $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour des stats: $e");
      return false;
    }
  }

  // ✨ MÉTHODE CORRIGÉE: Récupération de joueur avec le bon format d'ID
  static Future<Player?> getPlayerByName(String nom, String prenom) async {
    try {
      // Format cohérent: "prenom nom" (avec espace, en minuscules)
      String documentId = "${prenom.trim().toLowerCase()} ${nom.trim().toLowerCase()}";
      print("Recherche du joueur avec l'ID: $documentId");

      // Obtenir le document directement par son ID
      DocumentSnapshot doc = await _usersCollection.doc(documentId).get();

      if (!doc.exists) {
        print("Aucun joueur trouvé avec l'ID: $documentId");
        return null;
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Player.fromJson({
        'id': doc.id,
        ...data,
      });
    } catch (e) {
      print("Erreur lors de la récupération du joueur: $e");
      return null;
    }
  }

  // ✨ MÉTHODES CORRIGÉES pour gérer les nouveaux champs avec le bon format d'ID

  /// Met à jour le statut en ligne du joueur
  static Future<bool> updatePlayerOnlineStatus(String nom, String prenom, bool enligne) async {
    try {
      String documentId = "${prenom.trim().toLowerCase()} ${nom.trim().toLowerCase()}";
      
      await _usersCollection.doc(documentId).update({
        'EnLigne': enligne,
      });
      
      print("Statut en ligne mis à jour: $enligne pour $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour du statut: $e");
      return false;
    }
  }

  /// Met à jour l'arme et la portée du joueur
  static Future<bool> updatePlayerWeapon(String nom, String prenom, String arme, int portee) async {
    try {
      String documentId = "${prenom.trim().toLowerCase()} ${nom.trim().toLowerCase()}";
      
      await _usersCollection.doc(documentId).update({
        'arme': arme,
        'portee': portee,
      });
      
      print("Arme mise à jour: $arme (Portée: $portee) pour $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour de l'arme: $e");
      return false;
    }
  }

  /// Met à jour l'emplacement du joueur
  static Future<bool> updatePlayerLocation(String nom, String prenom, int emplacement) async {
    try {
      String documentId = "${prenom.trim().toLowerCase()} ${nom.trim().toLowerCase()}";
      
      await _usersCollection.doc(documentId).update({
        'emplacement': emplacement,
      });
      
      print("Emplacement mis à jour: $emplacement pour $documentId");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour de l'emplacement: $e");
      return false;
    }
  }

  // ✨ MÉTHODE BONUS: Surveillance en temps réel des connexions
  static Stream<List<Player>> watchOnlineUsers() {
    return _usersCollection
        .where('EnLigne', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Player.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }
}

// ✨ CLASSE pour gérer les résultats d'authentification
class AuthResult {
  final bool success;
  final String message;
  
  AuthResult({required this.success, required this.message});
}