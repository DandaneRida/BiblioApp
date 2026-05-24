// Le modèle représente une entité "Livre" dans l'application.
// Il sert de pont entre la base de données (Map) et le code Dart (objet).

class Livre {
  final int? id; // null avant insertion en BDD (auto-incrémenté)
  final String titre;
  final String auteur;
  final int? annee;
  final String? genre;
  final double? note; // note sur 5
  final bool lu;

  const Livre({
    this.id,
    required this.titre,
    required this.auteur,
    this.annee,
    this.genre,
    this.note,
    this.lu = false,
  });

  // Convertit l'objet Dart → Map pour SQLite
  Map<String, dynamic> toMap() => {
        'id': id,
        'titre': titre,
        'auteur': auteur,
        'annee': annee,
        'genre': genre,
        'note': note,
        'lu': lu ? 1 : 0, // SQLite n'a pas de type booléen natif
      };

  // Convertit un Map SQLite → objet Dart (factory constructor)
  factory Livre.fromMap(Map<String, dynamic> m) => Livre(
        id: m['id'],
        titre: m['titre'],
        auteur: m['auteur'],
        annee: m['annee'],
        genre: m['genre'],
        note: m['note'] != null ? (m['note'] as num).toDouble() : null,
        lu: m['lu'] == 1,
      );

  // copyWith : crée une copie avec certains champs modifiés
  // Indispensable avec BLoC car les états sont immuables
  Livre copyWith({
    int? id,
    String? titre,
    String? auteur,
    int? annee,
    String? genre,
    double? note,
    bool? lu,
  }) =>
      Livre(
        id: id ?? this.id,
        titre: titre ?? this.titre,
        auteur: auteur ?? this.auteur,
        annee: annee ?? this.annee,
        genre: genre ?? this.genre,
        note: note ?? this.note,
        lu: lu ?? this.lu,
      );
}
