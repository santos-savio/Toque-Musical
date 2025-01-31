import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/aula.dart';
import 'presenca_controller.dart';
import 'presenca_detalhe_page.dart';

class PresencaPage extends StatefulWidget {
  const PresencaPage({super.key});

  @override
  State<PresencaPage> createState() => _PresencaPageState();
}

class _PresencaPageState extends State<PresencaPage> {
  final controller = PresencaController();

  @override
  void initState() {
    super.initState();
    controller.obterAulas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text("Presença", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<List<Aula>>(
        stream: controller.aulas,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final aulas = snapshot.data!;
          return ListView.builder(
            itemCount: aulas.length,
            itemBuilder: (context, index) {
              final aula = aulas[index];
              return ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(aula.turmaNome ?? "Turma Desconhecida",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(aula.date)),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                subtitle: Text(aula.anotacao,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.grey),
                onTap: () {
                  controller.carregarPresencas(aula.id!, aula.turmaId!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PresencaDetalhePage(
                          controller: controller, aulaId: aula.id!),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
