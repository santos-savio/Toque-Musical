import 'package:flutter/material.dart';

import '../../models/aluno.dart';
import '../../models/turma.dart';
import 'alunos_controller.dart';

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  final controller = AlunosController();

  @override
  void initState() {
    super.initState();
    controller.getAllAlunos();
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
        title: const Text('Alunos'),
      ),
      body: StreamBuilder<List<Aluno>>(
          stream: controller.alunos,
          builder: (context, snapshot) {
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum aluno cadastrado'));
            }

            final alunos = snapshot.data!;
            return ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                return ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('${aluno.id} - ${aluno.nome}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditAlunoDialog(
                            context,
                            aluno.id,
                            aluno.nome,
                            aluno.turmaId,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(aluno.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAlunoDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAlunoDialog() {
    final textController = TextEditingController();
    Turma? turmaSelecionada;
    controller.getAllTurmas();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Aluno'),
          content: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'Nome do aluno'),
              ),
              StreamBuilder<List<Turma>>(
                stream: controller.turmas,
                builder: (context, snapshot) {
                  return DropdownButtonFormField<Turma>(
                    decoration: const InputDecoration(labelText: 'Turma'),
                    items: snapshot.data?.map((e) {
                      return DropdownMenuItem<Turma>(
                        value: e,
                        child: Text(e.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        turmaSelecionada = value;
                      });
                    },
                  );
                },
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
                final nome = textController.text;
                if (nome.isNotEmpty) {
                  controller.addAluno(nome, turmaSelecionada?.id);
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

  void _showEditAlunoDialog(
      BuildContext context, int id, String nomeAtual, int? turmaIdAtual) {
    final textController = TextEditingController(text: nomeAtual);
    controller.getAllTurmas();
    Turma? turmaSelecionada;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Aluno'),
          content: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: 'Novo nome do aluno'),
              ),
              StreamBuilder<List<Turma>>(
                stream: controller.turmas,
                builder: (context, snapshot) {
                  turmaSelecionada = turmaIdAtual == null
                      ? null
                      : snapshot.data?.cast<Turma?>().firstWhere(
                            (element) => element?.id == turmaIdAtual,
                            orElse: () => null,
                          );
                  return DropdownButtonFormField<Turma>(
                    value: turmaSelecionada,
                    decoration: const InputDecoration(labelText: 'Turma'),
                    items: snapshot.data?.map((e) {
                      return DropdownMenuItem<Turma>(
                        value: e,
                        child: Text(e.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        turmaSelecionada = value;
                      });
                    },
                  );
                },
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
                final novoNome = textController.text;
                if (novoNome.isNotEmpty) {
                  controller.editAluno(id, novoNome, turmaSelecionada?.id);
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

  void _showDeleteConfirmationDialog(int id) {
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
                controller.deleteAluno(id);
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
