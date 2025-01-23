import 'package:flutter/material.dart';

class RelatorioDeAulasPage extends StatelessWidget {
  const RelatorioDeAulasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Aulas'),
      ),
      body: const Center(
        child: Text('Conteúdo do Relatório de Aulas'),
      ),
    );
  }
}
