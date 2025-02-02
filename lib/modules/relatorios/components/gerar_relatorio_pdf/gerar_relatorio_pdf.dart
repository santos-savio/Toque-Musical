import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> gerarRelatorioPDF(pw.Widget relatorio) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(build: (pw.Context context) => relatorio));

  final path = await getPath();
  final file = File("$path/relatorio.pdf");
  await file.writeAsBytes(await pdf.save());
  await Printing.sharePdf(bytes: await pdf.save(), filename: "relatorio.pdf");
}

Future<String> getPath() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  } catch (e) {
    final tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }
}
