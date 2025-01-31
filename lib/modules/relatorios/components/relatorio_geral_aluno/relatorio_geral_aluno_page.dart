import 'package:flutter/material.dart';

class RelatorioGeralAlunoPage extends StatelessWidget {
  const RelatorioGeralAlunoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Geral do Aluno'),
      ),
      body: const Center(
        child: Text('Conteúdo do Relatório Geral do Aluno'),
      ),
    );
  }
}
