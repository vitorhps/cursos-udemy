import 'package:flutter/material.dart';

class EntradaSlider extends StatefulWidget {
  @override
  _EntradaSliderState createState() => _EntradaSliderState();
}

class _EntradaSliderState extends State<EntradaSlider> {

  double _value = 5.0;
  String _label = "Valor selecionado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados"),
      ),
      body: Container(
        padding: EdgeInsets.all(60),
        child: Column(
          children: <Widget>[
            
            Slider(
              value: _value,
              min: 0,
              max: 10,
              divisions: 5,
              label: _label,
              activeColor: Colors.red,
              inactiveColor: Colors.green,
              onChanged: (double value) {
                setState(() {
                  _value = value;
                  _label = "Valor selecionado " + value.toString();
                });
              },
            ),

            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              onPressed: () {
                print("Valor selecionado: " + _value.toString());
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
