import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../alunos/alunos_page.dart';
import '../turmas/turmas_page.dart';
import '../aulas/aulas_page.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    // ignore: dead_code
    if (false) await _deleteDatabase();

    await openDatabase(
      join(await getDatabasesPath(), 'toque_musical.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE turmas(id INTEGER PRIMARY KEY, descricao TEXT)');
        db.execute(
            'CREATE TABLE alunos(id INTEGER PRIMARY KEY, nome TEXT, turmaId INTEGER)');
        db.execute(
            'CREATE TABLE aulas(id INTEGER PRIMARY KEY, data DATE, duracao INTEGER, anotacao STRING)');
      },
      version: 1,
    );
  }

  Future<void> _deleteDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'toque_musical.db');
    await deleteDatabase(dbPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toque Musical'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _MenuCard(
              icon: Icons.person,
              label: 'Alunos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlunosPage()),
                );
              },
            ),
            _MenuCard(
              icon: Icons.group,
              label: 'Turmas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TurmasPage(),
                  ),
                );
              },
            ),
            _MenuCard(icon: Icons.calendar_today,
                label: 'Aulas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AulasPage(),
                  ),
                );
              },
            ),
            _MenuCard(icon: Icons.bar_chart, label: 'Relatórios'),
            _MenuCard(icon: Icons.info, label: 'Sobre'),
            _MenuCard(icon: Icons.person, label: 'Professor'),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
