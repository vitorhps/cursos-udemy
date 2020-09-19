import 'package:flutter/material.dart';

class EntradaCheckbox extends StatefulWidget {
  @override
  _EntradaCheckboxState createState() => _EntradaCheckboxState();
}

class _EntradaCheckboxState extends State<EntradaCheckbox> {

  bool _selected = false;
  bool _brazilianFood = false;
  bool _mexicanFood = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            /* Text("Comida Brasileira"),
            Checkbox(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
                print("Checkbox: " + value.toString());
              },
            ), */

            CheckboxListTile(
              title: Text("Comida Brasileira"),
              subtitle: Text("A melhor comida do mundo!!"),
              // activeColor: Colors.red,
              // selected: true,
              secondary: Icon(Icons.fastfood),
              value: _brazilianFood,
              onChanged: (bool value) {
                setState(() {
                  _brazilianFood = value;
                });
              }
            ),

            CheckboxListTile(
              title: Text("Comida Mexicana"),
              subtitle: Text("A segunda melhor comida do mundo!!"),
              secondary: Icon(Icons.fastfood),
              value: _mexicanFood,
              onChanged: (bool value) {
                setState(() {
                  _mexicanFood = value;
                });
              }
            ),

            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                print(
                  "Comida Brasileira: " + _brazilianFood.toString() +
                  " Comida Mexicana: " + _mexicanFood.toString()
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
