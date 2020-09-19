import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _cepController = TextEditingController();
  String _result = "Resultado";

  void _getCep() async {
    String cep = _cepController.text;
    String url = "https://viacep.com.br/ws/$cep/json/";

    http.Response response;

    response = await http.get(url);
    Map<String, dynamic> objResponse = jsonDecode(response.body);

    // print("Resposta: " + response.statusCode.toString());
    // print("Resposta: " + response.body);

    /*print("Logradouro: " + objResponse["logradouro"]);
    print("Complemento: " + objResponse["complemento"]);
    print("Bairro: " + objResponse["bairro"]);
    print("Localidade: " + objResponse["localidade"]);*/

    setState(() {
      _result = "${objResponse["bairro"]}, ${objResponse["localidade"]}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço web"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o CEP: ex: 01311300"
              ),
              style: TextStyle(
                fontSize: 20,
              ),
              controller: _cepController,
            ),
            RaisedButton(
              child: Text("Clique aqui"),
              onPressed: _getCep,
            ),
            Text(_result),
          ],
        ),
      )
    );
  }
}
