import 'package:cible_militaire/Services/authentificationService.dart';
import 'package:cible_militaire/Services/user_session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Initialise les données Firebase
Future<void> initializeData() async {
  await _dbRef.set({
    "Tete": {},
    "Ventre": {},
    "extr": {},
  });
}
  /// Écoute les changements de la section et les compteurs
  void listenToSectionChanges({
  required void Function() onHead,
  required void Function() onTorso,
  required void Function() onExtremity,
  required BuildContext context
}) {
  _dbRef.child("Tete").onChildAdded.listen((event) async {
     onHead();
     final userSession = Provider.of<UserSession>(context, listen: false);
    final currentPlayer = userSession.currentUser;
  
    print("current player complet: $currentPlayer"  );
     await AuthService.updateTete(currentPlayer!);
  });

  _dbRef.child("Ventre").onChildAdded.listen((event) async {
    onTorso();
      final userSession = Provider.of<UserSession>(context, listen: false);
    final currentPlayer = userSession.currentUser;
  
    print("current player complet: $currentPlayer"  );
     await AuthService.updateVentre(currentPlayer!);
  });

  _dbRef.child("extr").onChildAdded.listen((event) async {
    onExtremity();
      final userSession = Provider.of<UserSession>(context, listen: false);
    final currentPlayer = userSession.currentUser;
  
    print("current player complet: $currentPlayer"  );
     await AuthService.updateExtr(currentPlayer!);
  });
}


}
