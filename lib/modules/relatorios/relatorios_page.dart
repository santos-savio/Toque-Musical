import 'package:flutter/material.dart';

import 'components/relatorio_de_aulas_page.dart';
import 'components/relatorio_geral_aluno_page.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _navigateToRelatorioDeAulas(context);
              },
              icon: const Icon(Icons.menu_book),
              label: const Text(
                'Relatório de Aulas',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _navigateToRelatorioGeralAluno(context);
              },
              icon: const Icon(Icons.person),
              label: const Text(
                'Relatório Geral do Aluno',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRelatorioDeAulas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RelatorioDeAulasPage()),
    );
  }

  void _navigateToRelatorioGeralAluno(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RelatorioGeralAlunoPage()),
    );
  }
}