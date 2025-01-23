import 'package:flutter/material.dart';
import 'package:path/path.dart' hide context;
import 'package:sqflite/sqflite.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  late Database _database;
  List<Map<String, dynamic>> _aulas = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'toque_musical.db'));
    _fetchAulas();
  }

  Future<void> _fetchAulas() async {
    final List<Map<String, dynamic>> aulas = await _database.query('aulas');
    setState(() {
      _aulas = aulas;
    });
  }

  void _adicionarAula(Map<String, dynamic> novaAula) {
    setState(() {
      _aulas = List.from(_aulas)..add(novaAula);
    });
    Navigator.pop(context);
  }

  void _removerAula(int index) {
    setState(() {
      _aulas.removeAt(index);
    });
    Navigator.of(context).pop();
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir esta aula?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _removerAula(id),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAdicionarAulaModal() {
    final TextEditingController descricaoController = TextEditingController();
    String? duracao = '45';
    DateTime? dataSelecionada;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Aula'),
              content: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        dataSelecionada == null
                            ? 'Selecione a Data'
                            : 'Data: ${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dataSelecionada = pickedDate;
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: duracao,
                      decoration: const InputDecoration(labelText: 'Duração'),
                      items: [
                        '20',
                        '25',
                        '30',
                        '40',
                        '45',
                        '50',
                        '55',
                        '60',
                      ].map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text('$e minutos'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          duracao = value;
                        });
                      },
                    ),
                    TextField(
                      controller: descricaoController,
                      maxLength: 350,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dataSelecionada != null &&
                        descricaoController.text.isNotEmpty) {
                      _adicionarAula({
                        'descricao': descricaoController.text,
                        'data': dataSelecionada,
                        'duracao': duracao,
                      });
                    }
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
        title: const Text('Aulas'),
      ),
      body: _aulas.isEmpty
          ? const Center(child: Text('Nenhuma aula cadastrada'))
          : ListView.builder(
              itemCount: _aulas.length,
              itemBuilder: (context, index) {
                final aula = _aulas[index];
                final data = aula['data'] as DateTime;
                final formatedDate =
                    '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
                return ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(aula['descricao']),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatedDate),
                      Text('${aula['duracao']} min'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Função de edição pode ser implementada
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarAdicionarAulaModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
