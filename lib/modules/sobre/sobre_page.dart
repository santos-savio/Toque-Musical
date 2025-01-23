import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  String appVersion = "Carregando...";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Este aplicativo foi criado com o intuito de auxiliar o projeto Toque Musical a gerenciar as aulas e gerar relatórios para demonstração dos resultados.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Desenvolvido por Sávio Gabriel Santos\ne Emerson Ricardo Monteiro.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Versão: $appVersion",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
