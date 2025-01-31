import 'package:flutter/material.dart';
import 'package:toque_musical/modules/professor/professor_page.dart';
import 'package:toque_musical/modules/relatorios/relatorios_page.dart';
import 'package:toque_musical/modules/sobre/sobre_page.dart';

import '../alunos/alunos_page.dart';
import '../aulas/aulas_page.dart';
import '../presenca/presenca_page.dart';
import '../turmas/turmas_page.dart';
import 'widgets/card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toque Musical'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final childAspectRatio = (width / 2) / (((height - 10) / 4));
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: childAspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: 6,
                    (context, index) {
                      final items = [
                        MenuCard(
                          icon: Icons.person,
                          label: 'Alunos',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlunosPage(),
                              ),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.group,
                          label: 'Turmas',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TurmasPage(),
                              ),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.calendar_month,
                          label: 'Aulas',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AulasPage(),
                              ),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.person_pin,
                          label: 'Presença',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PresencaPage(),
                              ),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.supervisor_account,
                          label: 'Professor',
                          color: Colors.teal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfessorPage(),
                              ),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.bar_chart,
                          label: 'Relatórios',
                          color: Colors.red,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RelatoriosPage(),
                              ),
                            );
                          },
                        ),
                      ];

                      return items[index];
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    MenuCard(
                      icon: Icons.info,
                      label: 'Sobre',
                      color: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SobrePage(),
                          ),
                        );
                      },
                    )
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
