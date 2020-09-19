import 'package:flutter/material.dart';

class SecondaryScreen extends StatefulWidget {

  String value;

  SecondaryScreen({this.value});

  @override
  _SecondaryScreenState createState() => _SecondaryScreenState();
}

class _SecondaryScreenState extends State<SecondaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Secundária"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            // Text("Segunda tela! Valor passado: ${widget.value}"),
            Text("Segunda tela!!!"),


            RaisedButton(
              child: Text("Ir para tela principal"),
              padding: EdgeInsets.all(15),
              onPressed: () {
                // Navigator.pushNamed(context, "/");
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }
}
