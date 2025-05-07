import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Initialise les données Firebase
  Future<void> initializeData() async {
    await _dbRef.set({
      "section": "N",
      "Tete": 0,
      "Ventre": 0,
      "extr": 0,
    });
  }

  /// Écoute les changements de la section et appelle les fonctions associées
  void listenToSectionChanges({
    required void Function() onHead,
    required void Function() onTorso,
    required void Function() onExtremity,
  }) {
    _dbRef.child("section").onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == "Tete") {
        onHead();
      } else if (data == "Ventre") {
        onTorso();
      } else if (data == "extr") {
        onExtremity();
      }
    });
  }
}
