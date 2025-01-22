import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EditTurmaPage extends StatefulWidget {
  final Map<String, dynamic> turma;

  const EditTurmaPage({super.key, required this.turma});

  @override
  State<EditTurmaPage> createState() => _EditTurmaPageState();
}

class _EditTurmaPageState extends State<EditTurmaPage> {
  late Database _database;
  late TextEditingController _turmaDescricaoController;
  List<Map<String, dynamic>> _alunosTurma = [];
  List<Map<String, dynamic>> _alunosDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _turmaDescricaoController =
        TextEditingController(text: widget.turma['descricao']);
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'toque_musical.db'));
    _loadAlunos();
  }

  Future<void> _loadAlunos() async {
    final alunosDaTurma = await _database.query(
      'alunos',
      where: 'turmaId = ?',
      whereArgs: [widget.turma['id']],
    );
    final alunosNaoAdicionados = await _database.query(
      'alunos',
      where: 'turmaId IS NULL',
    );

    setState(() {
      _alunosTurma = alunosDaTurma;
      _alunosDisponiveis = alunosNaoAdicionados;
    });
  }

  Future<void> _removerAluno(int alunoId) async {
    await _database.update(
      'alunos',
      {'turmaId': null},
      where: 'id = ?',
      whereArgs: [alunoId],
    );
    _loadAlunos();
  }

  Future<void> _adicionarAlunos(
    List<int> alunosIds,
  ) async {
    for (final alunoId in alunosIds) {
      await _database.update(
        'alunos',
        {'turmaId': widget.turma['id']},
        where: 'id = ?',
        whereArgs: [alunoId],
      );
    }
    _loadAlunos();
  }

  Future<void> _salvarTurma() async {
    await _database.update(
      'turmas',
      {'descricao': _turmaDescricaoController.text},
      where: 'id = ?',
      whereArgs: [widget.turma['id']],
    );
  }

  void _mostrarAdicionarAlunosModal(
    BuildContext context,
  ) {
    List<int> selecionados = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Alunos'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: _alunosDisponiveis.length,
                  itemBuilder: (context, index) {
                    final aluno = _alunosDisponiveis[index];
                    return CheckboxListTile(
                      title: Text('${aluno['id']} - ${aluno['nome']}'),
                      value: selecionados.contains(aluno['id']),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selecionados.add(aluno['id']);
                          } else {
                            selecionados.remove(aluno['id']);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    _adicionarAlunos(selecionados);
                    Navigator.pop(context);
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Turma'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _turmaDescricaoController,
              decoration:
                  const InputDecoration(labelText: 'Nome da Turma'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _alunosTurma.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: const Text('Alunos da Turma'),
                  );
                }
                if (index == _alunosTurma.length + 1) {
                  return TextButton.icon(
                    onPressed: () => _mostrarAdicionarAlunosModal(context),
                    icon: const Icon(Icons.add),
                    label: Text('Adicionar Alunos'),
                  );
                }
                final aluno = _alunosTurma[index - 1];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('${aluno['id']} - ${aluno['nome']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removerAluno(aluno['id']),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  onPressed: () {
                    _salvarTurma();
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
