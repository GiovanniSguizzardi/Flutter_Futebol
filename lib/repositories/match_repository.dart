import '../database/app_database.dart';
import '../models/match_entry.dart';

class MatchRepository {
  Future<int> insert(MatchEntry match) async {
    final db = await AppDatabase.instance.database;

    final data = match.toMap();
    data.remove('id');

    return db.insert('matches', data);
  }

  Future<List<MatchEntry>> getByRound(int round) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'matches',
      where: 'round = ?',
      whereArgs: [round],
      orderBy: 'id ASC',
    );

    return result.map(MatchEntry.fromMap).toList();
  }

  Future<List<MatchEntry>> getAll() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('matches', orderBy: 'round ASC, id ASC');

    return result.map(MatchEntry.fromMap).toList();
  }

  Future<int> update(MatchEntry match) async {
    final db = await AppDatabase.instance.database;

    final data = match.toMap();
    data.remove('id');

    return db.update(
      'matches',
      data,
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return db.delete('matches', where: 'id = ?', whereArgs: [id]);
  }
}
