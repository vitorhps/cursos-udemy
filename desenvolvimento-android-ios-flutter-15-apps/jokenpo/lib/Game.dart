import 'dart:math';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {

  var _appImage = AssetImage("images/default.png");
  var _message = "Escolha uma opção abaixo";

  _selectOption(String userChoice) {

    var options = ["rock", "paper", "scissors"];
    var number = Random().nextInt(3);
    var appChoice = options[number];
    var message = "Você perdeu :(";

    if (userChoice == appChoice) {
      message = "Empatamos ;)";
    } else if (
      (userChoice == "rock" && appChoice == "scissors") ||
      (userChoice == "scissors" && appChoice == "paper") ||
      (userChoice == "paper" && appChoice == "rock")
    ) {
      message = "Parabéns!!! Você ganhou :)";
    }

    setState(() {
      _appImage = AssetImage("images/$appChoice.png");
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JokenPo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              "Escolha do App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Image(image: this._appImage),
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              this._message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () => _selectOption("rock"),
                child: Image.asset("images/rock.png", height: 100,),
              ),
              GestureDetector(
                onTap: () => _selectOption("paper"),
                child: Image.asset("images/paper.png", height: 100,),
              ),
              GestureDetector(
                onTap: () => _selectOption("scissors"),
                child: Image.asset("images/scissors.png", height: 100,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
