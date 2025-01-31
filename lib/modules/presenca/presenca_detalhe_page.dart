import 'package:flutter/material.dart';

import '../../models/presenca.dart';
import 'presenca_controller.dart';

class PresencaDetalhePage extends StatefulWidget {
  final PresencaController controller;
  final int aulaId;

  const PresencaDetalhePage(
      {super.key, required this.controller, required this.aulaId});

  @override
  State<PresencaDetalhePage> createState() => _PresencaDetalhePageState();
}

class _PresencaDetalhePageState extends State<PresencaDetalhePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Marcar Presença")),
      body: StreamBuilder<Map<int, List<Presenca>>>(
        stream: widget.controller.presencas,
        builder: (context, snapshot) {
          final presencaList = snapshot.data?[widget.aulaId] ?? [];

          return ListView.builder(
            itemCount: presencaList.length,
            itemBuilder: (context, index) {
              final presenca = presencaList[index];

              return ListTile(
                leading: Checkbox(
                  value: presenca.presente,
                  onChanged: (value) {
                    setState(() {
                      widget.controller.atualizarPresenca(
                          widget.aulaId, presenca.alunoId, value!);
                    });
                  },
                ),
                title: Text("Aluno ID: ${presenca.alunoId}"),
                trailing: IconButton(
                  icon: Icon(Icons.chat_bubble_outline),
                  onPressed: () =>
                      _mostrarModalObservacao(context, widget.aulaId, presenca),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            widget.controller.salvarPresencas(widget.aulaId);
            Navigator.pop(context);
          },
          child: Text("Salvar"),
        ),
      ),
    );
  }

  void _mostrarModalObservacao(
      BuildContext context, int aulaId, Presenca presenca) {
    TextEditingController obsController =
        TextEditingController(text: presenca.observacao);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Observação"),
          content: TextField(
            controller: obsController,
            decoration: InputDecoration(hintText: "Digite a observação"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.controller.atualizarObservacao(
                    aulaId, presenca.alunoId, obsController.text);
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}
