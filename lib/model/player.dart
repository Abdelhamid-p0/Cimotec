class Player {
  String nom;
  String prenom;
  String promotion;
  String brigade;
  String numeroListe;
  String bdeNumeroListe;
  Map<String, dynamic> resume;
  Map<String, dynamic> historiques;

  Player({
    required this.nom,
    required this.prenom,
    required this.promotion,
    required this.brigade,
    required this.numeroListe,
    required this.bdeNumeroListe,
    required this.resume,
    required this.historiques,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      promotion: json['promotion'] ?? '',
      brigade: json['Brigade'] ?? '',
      numeroListe: json['N° Liste'] ?? '',
      bdeNumeroListe: json['Bde'] ?? '',
      resume: json['résumé'] ?? {
        'Nombres de parties jouées': '0',
        'Moyennes de points par tir': '0',
        'nombres de tirs au tète': '0',
        'nombres de tirs au ventre': '0',
        'nombres de tirs au extrémité': '0',
        'nombres de tirs au manqué': '0',
      },
      historiques: json['historiques'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'promotion': promotion,
      'Brigade': brigade,
      'N° Liste': numeroListe,
      'Bde': bdeNumeroListe,
      'résumé': resume,
      'historiques': historiques,
    };
  }

  @override
  String toString() {
    return '''
Player{
      nom: $nom, 
      prenom: $prenom, 
      promotion: $promotion, 
      brigade: $brigade, 
      numeroListe: $numeroListe,
      bdeNumeroListe: $bdeNumeroListe,
      résumé: $resume,
      historiques: $historiques
    }''';
  }
}