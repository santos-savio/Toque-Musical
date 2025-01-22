import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage>{
  late Database _database;
  List<Map<String, dynamic>> _aulas = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
    await openDatabase(join(await getDatabasesPath(), 'toque_musical.db'));
    _fetchAulas();
  }

  Future<void> _fetchAulas() async {
    final List<Map<String, dynamic>> aulas = await _database.query('aulas');
    setState(() {
      _aulas = aulas;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aulas'),
      ),
      body: ListView.builder(
        itemCount: _aulas.length,
        itemBuilder: (context, index) {
        final aula = _aulas[index];
        return ListTile(
          leading: Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('${aula['id']} - ${aula['descricao']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: (){
                  _showEditAulaDialog(context, aula);
                },
              ),
              IconButton(icon: const Icon(Icons.delete),
              onPressed: (){
                _showDeleteConfirmationDialog(context, aula['id']);
              },
              ),
            ],
          ),
        );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showAddAulaDialog(context);
      },
      child: const Icon(Icons.add),
      ),
    );
  }







}

void _showAddAulaDialog(BuildContext context) {
}

void _showDeleteConfirmationDialog(BuildContext context, aula) {
}

void _showEditAulaDialog(BuildContext context, turma) {
}