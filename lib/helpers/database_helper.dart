import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  static Future<Database> _initializeDatabase() async {
    final path = join(await getDatabasesPath(), 'toque_musical.db');

    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE turmas(id INTEGER PRIMARY KEY, nome TEXT)',
        );

        await db.execute(
          '''
          CREATE TABLE alunos(
            id INTEGER PRIMARY KEY,
            nome TEXT,
            turmaId INTEGER,
            FOREIGN KEY(turmaId) REFERENCES turmas(id)
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE aulas(
            id INTEGER PRIMARY KEY,
            descricao TEXT,
            date TEXT,
            duration INTEGER
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE presenca(
            id INTEGER PRIMARY KEY,
            alunoId INTEGER,
            aulaId INTEGER,
            presente BOOLEAN,
            observacao TEXT,
            FOREIGN KEY(alunoId) REFERENCES alunos(id),
            FOREIGN KEY(aulaId) REFERENCES aulas(id)
          )
          ''',
        );

        await db.execute(
          'CREATE TABLE professor(id INTEGER PRIMARY KEY, nome TEXT)',
        );
      },
    );
  }
}
