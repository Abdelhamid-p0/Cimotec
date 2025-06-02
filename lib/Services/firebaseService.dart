import 'package:firebase_database/firebase_database.dart';

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
}) {
  _dbRef.child("Tete").onChildAdded.listen((event) {
    onHead();
  });

  _dbRef.child("Ventre").onChildAdded.listen((event) {
    onTorso();
  });

  _dbRef.child("extr").onChildAdded.listen((event) {
    onExtremity();
  });
}


}
