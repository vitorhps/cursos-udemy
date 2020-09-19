import 'package:flutter/material.dart';

class EntradaRadioButton extends StatefulWidget {
  @override
  _EntradaRadioButtonState createState() => _EntradaRadioButtonState();
}

class _EntradaRadioButtonState extends State<EntradaRadioButton> {

  String _gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            /* Text("Masculino"),
            Radio(
              value: "M",
              groupValue: _gender,
              onChanged: (String value) {
                setState(() {
                  _gender = value;
                });
              },
            ),

            Text("Feminino"),
            Radio(
              value: "F",
              groupValue: _gender,
              onChanged: (String value) {
                setState(() {
                  _gender = value;
                });
              },
            ), */

            RadioListTile(
              title: Text("Masculino"),
              value: "M",
              groupValue: _gender,
              onChanged: (String value) {
                setState(() {
                  _gender = value;
                });
              },
            ),

            RadioListTile(
              title: Text("Feminino"),
              value: "F",
              groupValue: _gender,
              onChanged: (String value) {
                setState(() {
                  _gender = value;
                });
              },
            ),

            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                print("Resultado: " + _gender);
              },
            ),

          ],
        ),
      ),
    );
  }
}
