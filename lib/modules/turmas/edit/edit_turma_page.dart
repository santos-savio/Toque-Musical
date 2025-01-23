import 'package:flutter/material.dart';

import '../../../models/aluno.dart';
import '../../../models/turma.dart';
import 'edit_turma_controller.dart';

class EditTurmaPage extends StatefulWidget {
  final Turma turma;

  const EditTurmaPage({super.key, required this.turma});

  @override
  State<EditTurmaPage> createState() => _EditTurmaPageState();
}

class _EditTurmaPageState extends State<EditTurmaPage> {
  final controller = EditTurmaController();

  @override
  void initState() {
    super.initState();
    controller.init(widget.turma);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              controller: controller.turmaDescricaoController,
              decoration:
                  const InputDecoration(labelText: 'Descrição da Turma'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Aluno>>(
              stream: controller.alunoDaTurma,
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final alunos = snapshot.data!;
                return ListView.builder(
                  itemCount: alunos.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: const Text('Alunos da Turma'),
                      );
                    }
                    if (index == alunos.length + 1) {
                      return TextButton.icon(
                        onPressed: _mostrarAdicionarAlunosModal,
                        icon: const Icon(Icons.add),
                        label: Text('Adicionar Alunos'),
                      );
                    }
                    final aluno = alunos[index - 1];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('${aluno.id} - ${aluno.nome}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removerAluno(aluno),
                      ),
                    );
                  },
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
                    controller.salvarTurma();
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

  void _mostrarAdicionarAlunosModal() {
    Set<Aluno> alunosAdicionados = {};

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
                child: StreamBuilder<List<Aluno>>(
                    stream: controller.alunosDisponiveis,
                    builder: (context, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final alunos = snapshot.data!;
                      if (alunos.isEmpty) {
                        return const Center(
                            child: Text("Não há alunos disponíveis"));
                      }
                      return ListView.builder(
                        itemCount: alunos.length,
                        itemBuilder: (context, index) {
                          final aluno = alunos[index];
                          return CheckboxListTile(
                            title: Text('${aluno.id} - ${aluno.nome}'),
                            value: alunosAdicionados.contains(aluno),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  alunosAdicionados.add(aluno);
                                } else {
                                  alunosAdicionados.remove(aluno);
                                }
                              });
                            },
                          );
                        },
                      );
                    }),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    controller.adicionarAlunos(alunosAdicionados);
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
}
