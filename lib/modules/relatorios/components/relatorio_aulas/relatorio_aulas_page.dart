import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'relatorio_aulas_controller.dart';
import 'resultado_relatorio/resultado_relatorio_page.dart';

class RelatorioAulasPage extends StatefulWidget {
  const RelatorioAulasPage({super.key});

  @override
  State<RelatorioAulasPage> createState() => _RelatorioAulasPageState();
}

class _RelatorioAulasPageState extends State<RelatorioAulasPage> {
  final controller = RelatorioAulasController();
  DateTime dataInicio = DateTime(DateTime.now().year, 1, 1);
  DateTime dataFinal = DateTime.now();

  Future<void> _selecionarDataInicio(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dataInicio,
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked.isBefore(dataFinal)) {
      setState(() {
        dataInicio = picked;
      });
    }
  }

  Future<void> _selecionarDataFinal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dataFinal,
      firstDate: dataInicio,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked.isAfter(dataInicio)) {
      setState(() {
        dataFinal = picked;
      });
    }
  }

  void _consultarRelatorio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoRelatorioPage(
          relatorio: controller.obterRelatorioAulas(dataInicio, dataFinal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Relatório de Aulas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Defina um período",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                  "Data de Início: ${DateFormat('dd/MM/yyyy').format(dataInicio)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selecionarDataInicio(context),
            ),
            ListTile(
              title: Text(
                  "Data de Final: ${DateFormat('dd/MM/yyyy').format(dataFinal)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selecionarDataFinal(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _consultarRelatorio,
              child: Center(child: Text("Consultar")),
            ),
          ],
        ),
      ),
    );
  }
}
