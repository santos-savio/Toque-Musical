import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'edit_turma_page.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage({super.key});

  @override
  State<TurmasPage> createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage> {
  late Database _database;
  List<Map<String, dynamic>> _turmas = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'toque_musical.db'));
    _fetchTurmas();
  }

  Future<void> _fetchTurmas() async {
    final List<Map<String, dynamic>> turmas = await _database.query('turmas');
    setState(() {
      _turmas = turmas;
    });
  }

  Future<void> _addTurma(String descricao) async {
    await _database.insert(
      'turmas',
      {'descricao': descricao},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchTurmas();
  }

  Future<void> _deleteTurma(int id) async {
    await _database.delete(
      'turmas',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _database.update(
      'alunos',
      {'turmaId': null},
      where: 'turmaId = ?',
      whereArgs: [id],
    );
    _fetchTurmas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
      ),
      body: ListView.builder(
        itemCount: _turmas.length,
        itemBuilder: (context, index) {
          final turma = _turmas[index];
          return ListTile(
            leading: Icon(
              Icons.group,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('${turma['id']} - ${turma['descricao']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditTurmaDialog(context, turma);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, turma['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTurmaDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTurmaDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Turma'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: 'Descrição da turma'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    final descricao = controller.text;
                    if (descricao.isNotEmpty) {
                      _addTurma(descricao);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTurmaDialog(BuildContext context, Map<String, dynamic> turma) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTurmaPage(turma: turma),
      ),
    ).then((_) => _fetchTurmas());
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir esta turma?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteTurma(id);
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
