import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../models/relatorio_aulas.dart';
import '../../gerar_relatorio_pdf/gerar_relatorio_pdf.dart';
import 'resultado_relatorio_pdf.dart';

class ResultadoRelatorioPage extends StatelessWidget {
  final Future<List<RelatorioAula>> relatorio;

  const ResultadoRelatorioPage({super.key, required this.relatorio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Relatório de Aulas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "Relatório de Aulas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<RelatorioAula>>(
                  future: relatorio,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Ocorreu um erro inesperado, tente novamente ou entre em contato com o suporte'),
                      );
                    }

                    if (snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Nenhum registro encontrado'));
                    }

                    final relatorio = snapshot.data!;
                    return ListView.builder(
                      itemCount: relatorio.length,
                      itemBuilder: (context, index) {
                        final aula = relatorio[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Aula - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(aula.date))}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Duração: ${aula.duration} min"),
                                  ],
                                ),
                                Text("Anotação: ${aula.anotacao}"),
                                const SizedBox(height: 10),
                                Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                  },
                                  children: [
                                    const TableRow(
                                      decoration:
                                          BoxDecoration(color: Colors.black12),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Aluno",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Turma",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...aula.alunoTurma.map(
                                      (aluno) => TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(aluno.alunoNome),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(aluno.turmaNome),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _mostrarCarregando(context);
          await gerarRelatorioPDF(resultadoRelatorioPDF(await relatorio));
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.print),
      ),
    );
  }

  void _mostrarCarregando(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Gerando relatório..."),
            ],
          ),
        );
      },
    );
  }
}
