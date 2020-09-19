import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhas_viagens/Maps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore _db = Firestore.instance;

  _openMap(String tripId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Maps(tripId: tripId),
      ),
    );
  }

  _deleteTrip(String tripId) {
    _db.collection("travels").document(tripId).delete();
  }

  _addLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Maps()),
    );
  }

  _addTravelListener() async {
    final stream = _db.collection("travels").snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  @override
  void initState() {
    super.initState();

    _addTravelListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Viagens"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff0066cc),
        onPressed: _addLocation,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:

              QuerySnapshot querySnapshot = snapshot.data;
              List<DocumentSnapshot> travels = querySnapshot.documents.toList();



              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: travels.length,
                      itemBuilder: (context, index) {

                        DocumentSnapshot item = travels[index];

                        return GestureDetector(
                          onTap: () => _openMap(item.documentID),
                          child: Card(
                            child: ListTile(
                              title: Text(item["title"]),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _deleteTrip(item.documentID),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
              break;
          }
          return Container();
        },
      ),
    );
  }
}
