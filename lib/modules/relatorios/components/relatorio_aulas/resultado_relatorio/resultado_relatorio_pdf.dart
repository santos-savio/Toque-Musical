import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../../../models/relatorio_aulas.dart';

Widget resultadoRelatorioPDF(List<RelatorioAula> relatorio) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          "Relatório de Aulas",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 10),
      for (final aula in relatorio)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Aula - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(aula.date))}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("Duração: ${aula.duration} min"),
              ],
            ),
            Text("Anotação: ${aula.anotacao}"),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: PdfColors.grey300),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Aluno",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Turma",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...aula.alunoTurma.map(
                  (aluno) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(aluno.alunoNome),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(aluno.turmaNome),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
    ],
  );
}
