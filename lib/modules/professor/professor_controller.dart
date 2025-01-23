import 'package:sqflite/sqflite.dart';

import '../../helpers/database_helper.dart';
import '../../models/professor.dart';

class ProfessorController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Professor>> getProfessores() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query('professor');
    return result.map((e) => Professor.fromMap(e)).toList();
  }

  Future<void> addProfessor(String nome) async {
    final db = await _dbHelper.database;
    await db.insert(
      'professor',
      Professor(nome: nome).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> editProfessor(int id, String nome) async {
    final db = await _dbHelper.database;
    await db.update(
      'professor',
      {'nome': nome},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteProfessor(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'professor',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
