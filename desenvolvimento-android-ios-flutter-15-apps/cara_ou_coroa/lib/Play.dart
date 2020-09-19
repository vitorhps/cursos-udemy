import 'dart:math';

import 'package:cara_ou_coroa/Result.dart';
import 'package:flutter/material.dart';

class Play extends StatefulWidget {
  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {

  void _showResult() {

    var _items = ["heads", "tails"];
    var number = Random().nextInt(_items .length);
    var result = _items[number];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Result(result),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xff61bd86),
      // backgroundColor: Color.fromRGBO(255, 204, 128, 1),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset("images/logo.png"),
            GestureDetector(
              onTap: _showResult,
              child: Image.asset("images/botao_jogar.png"),
            ),
          ],
        ),
      ),
    );
  }
}
