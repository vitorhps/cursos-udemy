import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _savedText = "Nada Salvo!";
  TextEditingController _fieldController = TextEditingController();

  void _save() async {
    String value = _fieldController.text;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("savedText", value);
  }

  void _get() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedText = prefs.getString("savedText") ?? "Sem valor";
    });
  }

  void _remove() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("savedText");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manipulação de dados"),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Text(
              _savedText,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Digite algo",
              ),
              controller: _fieldController,
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: _save,
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Recuperar",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: _get,
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Remover",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: _remove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
