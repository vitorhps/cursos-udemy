import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frases do Dia',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Frases do Dia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _randomNumber = 0;
  List<String> _phrases = [
    "O importante não é vencer todos os dias, mas lutar sempre.",
    "É melhor consquistar a si mesmo do que vencer mil batalhas.",
    "O medo de perder tira a vontade de ganhar.",
    "Perder para a razão, sempre é ganhar.",
  ];

  void _generateRandomNumber() {
    setState(() {
      _randomNumber = new Random().nextInt(_phrases.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pressione o botão para gerar uma frase',
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                _phrases[_randomNumber],
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateRandomNumber,
        tooltip: 'Generate Phrase',
        child: Icon(Icons.add),
      ),
    );
  }
}
