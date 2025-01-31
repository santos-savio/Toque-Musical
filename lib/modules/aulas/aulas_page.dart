import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toque_musical/modules/aulas/aulas_controller.dart';

import '../../models/aula.dart';
import '../../models/turma.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  final controller = AulasController();

  @override
  void initState() {
    super.initState();
    controller.obterAulas();
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
              onPressed: () {
                controller.removerAula(id);
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAulaModal([Aula? aula]) {
    final anotacaoController = TextEditingController();

    String? duracao = '45';
    DateTime? dataSelecionada;
    var titulo = 'Adicionar Aula';
    var botao = 'Adicionar';
    Turma? turmaSelecionada;
    int? turmaId;

    if (aula != null) {
      anotacaoController.text = aula.anotacao;
      duracao = aula.duration.toString();
      dataSelecionada = DateTime.parse(aula.date);
      titulo = 'Editar Aula';
      botao = 'Salvar';
      turmaId = aula.turmaId;
    }

    controller.getAllTurmas();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(titulo),
              content: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        dataSelecionada == null
                            ? 'Selecione a data e hora'
                            : '${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year} - ${dataSelecionada!.hour.toString().padLeft(2, '0')}:${dataSelecionada!.minute.toString().padLeft(2, '0')}',
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
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            setState(() {
                              dataSelecionada = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
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
                    StreamBuilder<List<Turma>>(
                      stream: controller.turmas,
                      builder: (context, snapshot) {
                        final turma = snapshot.data?.where(
                          (element) => element.id == turmaId,
                        );

                        if (turma != null && turma.isNotEmpty) {
                          turmaSelecionada = turma.first;
                        }

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
                            turmaSelecionada = value;
                          },
                        );
                      },
                    ),
                    TextField(
                      controller: anotacaoController,
                      maxLength: 350,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Anotação',
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
                    if (anotacaoController.text.isNotEmpty) {
                      final aulaModel = Aula(
                        id: aula?.id,
                        anotacao: anotacaoController.text,
                        date: dataSelecionada!.toIso8601String(),
                        duration: int.parse(duracao!),
                        turmaId: turmaSelecionada?.id,
                      );
                      if (aula == null) {
                        controller.adicionarAula(aulaModel);
                      } else {
                        controller.editarAula(aulaModel);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(botao),
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
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<List<Aula>>(
          stream: controller.aulas,
          builder: (context, snapshot) {
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum aula cadastrado'));
            }

            final alunos = snapshot.data!;
            return ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aula = alunos[index];
                final formatedDate = DateFormat('dd/MM/yyyy HH:mm')
                    .format(DateTime.parse(aula.date));
                return ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatedDate),
                      Text('${aula.duration} min'),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(aula.anotacao),
                      Text(aula.turmaNome ?? 'Turma Desconhecida'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _mostrarAulaModal(aula);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _showDeleteConfirmationDialog(aula.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarAulaModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
