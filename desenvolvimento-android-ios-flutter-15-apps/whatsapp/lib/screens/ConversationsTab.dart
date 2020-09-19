import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversation.dart';
import 'package:whatsapp/model/User.dart';

class ConversationsTab extends StatefulWidget {
  @override
  _ConversationsTabState createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {

  Firestore db = Firestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _loggedUserId;

  Stream<QuerySnapshot> _addConversationListener() {
    final stream = db.collection("conversations")
        .document(_loggedUserId)
        .collection("last_conversation")
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  _retriveUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();

    setState(() {
      _loggedUserId = loggedUser.uid;
    });

    _addConversationListener();
  }

  @override
  void initState() {
    super.initState();

    _retriveUserData();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.close();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:

            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            } else {

              QuerySnapshot querySnapshot = snapshot.data;

              if (querySnapshot.documents.length == 0) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :(",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (context, index) {
                  List<DocumentSnapshot> conversations = querySnapshot
                    .documents
                    .toList();
                  DocumentSnapshot item = conversations[index];

                  String imageUrl = item["imageUrl"];
                  String type= item["type"];
                  String name = item["name"];
                  String message = item["message"];
                  String receiver = item["receiver"];

                  User user = User();
                  user.name = name;
                  user.imageUrl = imageUrl;
                  user.userId = receiver;

                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/messages",
                        arguments: user,
                      );
                    },
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl)
                      : null,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      type == "text" ? message : "Imagem...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              );

            }

            break;
        }
        return Container();
      },
    );
  }
}
