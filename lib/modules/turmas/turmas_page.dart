import 'package:flutter/material.dart';

import '../../models/turma.dart';
import 'edit/edit_turma_page.dart';
import 'turmas_controller.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage({super.key});

  @override
  State<TurmasPage> createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage> {
  final controller = TurmasController();

  @override
  void initState() {
    super.initState();
    controller.getAllTurmas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
      ),
      body: StreamBuilder<List<Turma>>(
          stream: controller.turmas,
          builder: (context, snapshot) {
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma turma cadastrada'));
            }

            final turmas = snapshot.data!;
            return ListView.builder(
              itemCount: turmas.length,
              itemBuilder: (context, index) {
                final turma = turmas[index];
                return ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('${turma.id} - ${turma.nome}'),
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
                          _showDeleteConfirmationDialog(context, turma.id);
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
          _showAddTurmaDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTurmaDialog(BuildContext context) {
    final textController = TextEditingController();
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
                    controller: textController,
                    decoration:
                        const InputDecoration(hintText: 'Nome da turma'),
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
                    final descricao = textController.text;
                    if (descricao.isNotEmpty) {
                      controller.addTurma(descricao);
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

  void _showEditTurmaDialog(BuildContext context, Turma turma) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTurmaPage(turma: turma),
      ),
    ).then((_) => controller.getAllTurmas());
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
                controller.deleteTurma(id);
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
