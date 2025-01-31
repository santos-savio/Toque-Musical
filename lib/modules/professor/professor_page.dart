import 'package:flutter/material.dart';

import '../../models/professor.dart';
import 'professor_controller.dart';

class ProfessorPage extends StatefulWidget {
  const ProfessorPage({super.key});

  @override
  State<ProfessorPage> createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  final _controller = ProfessorController();
  List<Professor> _professores = [];

  @override
  void initState() {
    super.initState();
    _loadProfessores();
  }

  Future<void> _loadProfessores() async {
    final professores = await _controller.getProfessores();
    setState(() {
      _professores = professores;
    });
  }

  Future<void> _addProfessor() async {
    final nomeController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Professor'),
          content: TextField(
            controller: nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomeController.text.isNotEmpty) {
                  await _controller.addProfessor(nomeController.text);
                  await _loadProfessores();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProfessor(Professor professor) async {
    final TextEditingController nomeController =
        TextEditingController(text: professor.nome);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Professor'),
          content: TextField(
            controller: nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomeController.text.isNotEmpty) {
                  await _controller.editProfessor(
                      professor.id!, nomeController.text);
                  await _loadProfessores();
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProfessor(int id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Professor'),
          content: const Text('Tem certeza que deseja excluir este professor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _controller.deleteProfessor(id);
                await _loadProfessores();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professor'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _professores.length,
        itemBuilder: (context, index) {
          final professor = _professores[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(professor.nome),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editProfessor(professor),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProfessor(professor.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProfessor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
