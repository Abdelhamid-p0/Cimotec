class Player {
  String? id;
  String nom;
  String prenom;
  String promotion;
  String brigade;
  String numeroListe;
  int parties;
  int points;
  int tete;
  int ventre;
  int extremite;
  int emplacement;    // ← Nouveau champ ajouté
  bool enligne;       // ← Nouveau champ ajouté
  int portee;         // ← Nouveau champ ajouté
  String arme;        // ← Nouveau champ ajouté

  Player({
    this.id,
    required this.nom,
    required this.prenom,
    required this.promotion,
    required this.brigade,
    required this.numeroListe,
    this.parties = 0,
    this.points = 0,
    this.tete = 0,
    this.ventre = 0,
    this.extremite = 0,
    this.emplacement = 0,      // ← Valeur par défaut
    this.enligne = false,      // ← Valeur par défaut
    this.portee = 0,           // ← Valeur par défaut
    this.arme = "",            // ← Valeur par défaut
  });

  /// Factory pour créer un Player depuis les données Firebase
  factory Player.fromJson(Map<String, dynamic> json) {
    // Fonction helper pour parser les entiers de manière sécurisée
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (_) {
          return 0;
        }
      }
      return 0;
    }

    // Fonction helper pour parser les booléens de manière sécurisée
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return false;
    }

    return Player(
      id: json['id']?.toString(),
      nom: (json['nom'] ?? '').toString(),
      prenom: (json['prenom'] ?? '').toString(),
      promotion: (json['promotion'] ?? '').toString(),
      brigade: (json['brigade'] ?? '').toString(),
      numeroListe: (json['numeroListe'] ?? '').toString(),
      parties: parseInt(json['parties']),
      points: parseInt(json['points']),
      tete: parseInt(json['tete']),
      ventre: parseInt(json['ventre']),
      extremite: parseInt(json['extremite']),
      emplacement: parseInt(json['emplacement']),    // ← Nouveau
      enligne: parseBool(json['enligne']),           // ← Nouveau
      portee: parseInt(json['portee']),              // ← Nouveau
      arme: (json['arme'] ?? '').toString(),         // ← Nouveau
    );
  }

  /// Convertit le Player en Map pour l'envoyer à Firebase
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'promotion': promotion,
      'brigade': brigade,
      'numeroListe': numeroListe,
      'parties': parties,
      'points': points,
      'tete': tete,
      'ventre': ventre,
      'extremite': extremite,
      'emplacement': emplacement,    // ← Nouveau
      'EnLigne': enligne,            // ← Nouveau
      'portee': portee,              // ← Nouveau
      'arme': arme,                  // ← Nouveau
    };
  }

  /// Crée une copie du Player avec des modifications optionnelles
  Player copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? promotion,
    String? brigade,
    String? numeroListe,
    int? parties,
    int? points,
    int? tete,
    int? ventre,
    int? extremite,
    int? emplacement,
    bool? enligne,
    int? portee,
    String? arme,
  }) {
    return Player(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      promotion: promotion ?? this.promotion,
      brigade: brigade ?? this.brigade,
      numeroListe: numeroListe ?? this.numeroListe,
      parties: parties ?? this.parties,
      points: points ?? this.points,
      tete: tete ?? this.tete,
      ventre: ventre ?? this.ventre,
      extremite: extremite ?? this.extremite,
      emplacement: emplacement ?? this.emplacement,
      enligne: enligne ?? this.enligne,
      portee: portee ?? this.portee,
      arme: arme ?? this.arme,
    );
  }

  @override
  String toString() {
    return 'Player(id: $id, nom: $nom, prenom: $prenom, promotion: $promotion, '
           'brigade: $brigade, parties: $parties, points: $points, enligne: $enligne, '
           'arme: $arme, emplacement: $emplacement, portee: $portee)';
  }

  /// Méthodes utilitaires pour les statistiques
  
  /// Calcule la moyenne de points par partie
  double get moyennePoints {
    if (parties == 0) return 0.0;
    return points / parties;
  }

  /// Calcule le total des tirs réussis
  int get totalTirsReussis {
    return tete + ventre + extremite;
  }

  /// Calcule le pourcentage de précision (si vous avez le nombre total de tirs)
  double calculerPourcentagePrecision(int totalTirs) {
    if (totalTirs == 0) return 0.0;
    return (totalTirsReussis / totalTirs) * 100;
  }

  /// Retourne le statut de connexion sous forme de texte
  String get statutConnexion {
    return enligne ? "En ligne" : "Hors ligne";
  }

  /// Retourne une description de l'arme et de la portée
  String get descriptionArme {
    if (arme.isEmpty) return "Aucune arme";
    return "$arme (Portée: ${portee}m)";
  }
}