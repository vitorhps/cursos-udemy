import 'package:atm_consultoria/CompanyScreen.dart';
import 'package:atm_consultoria/ContactScreen.dart';
import 'package:atm_consultoria/CustomersScreen.dart';
import 'package:atm_consultoria/ServicesScreen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _openCompany() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompanyScreen())
    );
  }

  void _openServices() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServicesScreen())
    );
  }

  void _openCustomers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomersScreen())
    );
  }

  void _openContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ATM Consultoria"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Image.asset("images/logo.png"),
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: Image.asset("images/menu_empresa.png"),
                    onTap: _openCompany,
                  ),
                  GestureDetector(
                    child: Image.asset("images/menu_servico.png"),
                    onTap: _openServices,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: Image.asset("images/menu_cliente.png"),
                    onTap: _openCustomers,
                  ),
                  GestureDetector(
                    child: Image.asset("images/menu_contato.png"),
                    onTap: _openContact,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
