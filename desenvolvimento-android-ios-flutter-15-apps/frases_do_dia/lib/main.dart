import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Frases do Dia",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _phrases = [
    "O importante não é vencer todos os dias, mas lutar sempre.",
    "Maior que a tristeza de não haver vencido é a vergonha de não ter lutado!",
    "É melhor conquistar a si mesmo do que vencer mil batalhas.",
    "Quem ousou conquistar e saiu pra lutar, chega mais longe!",
    "Enquanto houver vontade de lutar haverá esperança de vencer.",
    "Difícil é ganhar um amigo em uma hora; fácil é ofendê-lo em um minuto.",
  ];

  var _generatedPhrase = "Clique abaixo para gerar uma frase";

  void _generatePhrase() {
    var randomNumber = Random().nextInt(_phrases.length);

    setState(() {
      _generatedPhrase = _phrases[randomNumber];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frases do Dia"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/logo.png"),
              Text(
                _generatedPhrase,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
              RaisedButton(
                child: Text(
                  "Nova Frase",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                color: Colors.green,
                onPressed: _generatePhrase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
