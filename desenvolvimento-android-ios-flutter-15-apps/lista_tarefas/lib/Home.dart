import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _taskList = [];
  Map<String, dynamic> _lastTaskRemoved = Map();
  TextEditingController _taskController = TextEditingController();

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  _saveFile() async {
    var file = await _getFile();

    String data = jsonEncode(_taskList);
    file.writeAsString(data);
  }

  _readFile() async {
    try {

      final file = await _getFile();
      return file.readAsString() ?? [];

    } catch (e) {
      return [];
    }
  }

  _saveTask() {
    String taskTitle = _taskController.text;

    Map<String, dynamic> task = Map();
    task["title"] = taskTitle;
    task["done"] = false;

    setState(() {
      _taskList.add(task);
    });
    _saveFile();

    _taskController.text = "";
  }

  Widget createListItem(context, index) {

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {

        setState(() {
          _lastTaskRemoved = _taskList[index];
        });

        _taskList.removeAt(index);
        _saveFile();

        final snackbar = SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Tarefa removida!!"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _taskList.insert(index, _lastTaskRemoved);
              });
              _saveFile();
            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
      ),
      child: CheckboxListTile(
        title: Text(_taskList[index]["title"]),
        value: _taskList[index]["done"],
        onChanged: (value) {
          setState(() {
            _taskList[index]["done"] = value;
          });
          _saveFile();
        },
      ),
    );

  }

  @override
  void initState() {
    super.initState();

    _readFile().then((data) {
      setState(() {
        _taskList = jsonDecode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () {

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Adicionar Tarefa"),
                content: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: "Digite sua tarefa",
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("Salvar"),
                    onPressed: () {
                      _saveTask();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );

        },
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _taskList.length,
              itemBuilder: createListItem,
            ),
          ),
        ],
      ),
    );
  }
}
