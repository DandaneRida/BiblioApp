import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Singleton : une seule instance de DatabaseHelper dans toute l'app.
// Garantit qu'il n'y a qu'une connexion ouverte à la base de données.
class DatabaseHelper {
  // Instance unique (Singleton pattern)
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  // Constructeur privé → empêche l'instanciation externe
  DatabaseHelper._internal();

  // Getter asynchrone : initialise la BDD si nécessaire, sinon retourne l'existante
  Future<Database> get database async {
    _database ??=
        await _initDatabase(); // opérateur ??= : assigne seulement si null
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // getDatabasesPath() : répertoire standard de l'OS pour les BDD
    // join() : construit le chemin complet de manière portable
    final path = join(await getDatabasesPath(), 'biblio_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Appelé une seule fois : lors de la toute première ouverture de la BDD
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE livres (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        titre   TEXT    NOT NULL,
        auteur  TEXT    NOT NULL,
        annee   INTEGER,
        genre   TEXT,
        note    REAL,
        lu      INTEGER DEFAULT 0
      )
    ''');
  }
}
