import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _items = [];

  void _loadItems() {

    _items = [];

    for(int i = 0; i <= 10; i++) {

      Map<String, dynamic> item = Map();
      item["title"] = "Título $i Lorem ipsum dolor sit amet.";
      item["description"] = "Descrição $i Lorem ipsum dolor sit amet.";
      _items.add(item);

    }
  }

  @override
  Widget build(BuildContext context) {

    _loadItems();

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {

            Map<String, dynamic> item = _items[index];

            return ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(item["title"]),
                      titlePadding: EdgeInsets.all(20),
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                      ),
                      content: Text(item["description"]),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            print("Selecionado não - Item " + index.toString());
                            // Navigator.pop(context);
                          },
                          child: Text("Não"),
                        ),
                        FlatButton(
                          onPressed: () {
                            print("Selecionado sim - Item " + index.toString());
                            Navigator.pop(context);
                          },
                          child: Text("Sim"),
                        ),
                      ],
                    );
                  }
                );
              },
              title: Text(item["title"]),
              subtitle: Text(item["description"]),
            );
          },
        ),
      ),
    );
  }
}
