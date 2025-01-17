import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  late Database _database;
  List<Map<String, dynamic>> _alunos = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'toque_musical.db'));
    _fetchAlunos();
  }

  Future<void> _fetchAlunos() async {
    final List<Map<String, dynamic>> alunos = await _database.query('alunos');
    setState(() {
      _alunos = alunos;
    });
  }

  Future<void> _addAluno(String nome) async {
    await _database.insert(
      'alunos',
      {'nome': nome},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchAlunos();
  }

  Future<void> _editAluno(int id, String novoNome) async {
    await _database.update(
      'alunos',
      {'nome': novoNome},
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchAlunos();
  }

  Future<void> _deleteAluno(int id) async {
    await _database.delete(
      'alunos',
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
      ),
      body: ListView.builder(
        itemCount: _alunos.length,
        itemBuilder: (context, index) {
          final aluno = _alunos[index];
          return ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('${aluno['id']} - ${aluno['nome']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditAlunoDialog(context, aluno['id'], aluno['nome']);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, aluno['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAlunoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAlunoDialog(
    BuildContext context,
  ) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Aluno'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nome do aluno'),
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
                final nome = controller.text;
                if (nome.isNotEmpty) {
                  _addAluno(nome);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditAlunoDialog(BuildContext context, int id, String nomeAtual) {
    final TextEditingController controller =
        TextEditingController(text: nomeAtual);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Aluno'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Novo nome do aluno'),
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
                final novoNome = controller.text;
                if (novoNome.isNotEmpty) {
                  _editAluno(id, novoNome);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir este aluno?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteAluno(id);
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
