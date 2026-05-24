import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/livre.dart';

// Le Repository est la couche d'abstraction entre le BLoC et la BDD.
// Le BLoC ne connaît pas SQLite, il appelle seulement le Repository.
// Si on change de BDD demain, seul ce fichier change.
class LivreRepository {
  final _dbHelper = DatabaseHelper.instance;

  // CREATE — Insère un nouveau livre, retourne l'ID généré
  Future<int> creer(Livre livre) async {
    final db = await _dbHelper.database;
    return db.insert(
      'livres',
      livre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ ALL — Retourne tous les livres triés par titre
  Future<List<Livre>> lireTous() async {
    final db = await _dbHelper.database;
    final maps = await db.query('livres', orderBy: 'titre ASC');
    return maps.map(Livre.fromMap).toList();
  }

  // READ ONE — Retourne un livre par son ID (ou null si introuvable)
  Future<Livre?> lireParId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'livres',
      where: 'id = ?',
      whereArgs: [id], // évite les injections SQL
    );
    return maps.isNotEmpty ? Livre.fromMap(maps.first) : null;
  }

  // UPDATE — Met à jour un livre existant, retourne le nombre de lignes modifiées
  Future<int> mettreAJour(Livre livre) async {
    final db = await _dbHelper.database;
    return db.update(
      'livres',
      livre.toMap(),
      where: 'id = ?',
      whereArgs: [livre.id],
    );
  }

  // DELETE — Supprime un livre par ID
  Future<int> supprimer(int id) async {
    final db = await _dbHelper.database;
    return db.delete('livres', where: 'id = ?', whereArgs: [id]);
  }

  // RECHERCHE — Filtre par titre ou auteur (LIKE = contient)
  Future<List<Livre>> rechercher(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'livres',
      where: 'titre LIKE ? OR auteur LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map(Livre.fromMap).toList();
  }

  // FILTRE PAR GENRE
  Future<List<Livre>> filtrerParGenre(String genre) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'livres',
      where: 'genre = ?',
      whereArgs: [genre],
      orderBy: 'titre ASC',
    );
    return maps.map(Livre.fromMap).toList();
  }
}
