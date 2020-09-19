import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/User.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {

  String _loggedUserId;
  String _loggedUserEmail;

  Future<List<User>> _retriveContacts() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection("users")
      .orderBy("name", descending: false)
      .getDocuments();

    List<User> userList = List();

    for(DocumentSnapshot item in querySnapshot.documents) {
      var data = item.data;

      if (data["email"] == _loggedUserEmail) continue;

      User user = User();
      user.userId = item.documentID;
      user.name = data["name"];
      user.email = data["email"];
      user.imageUrl = data["imageUrl"];

      userList.add(user);
    }

    return userList;
  }

  _retriveUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();

    setState(() {
      _loggedUserId = loggedUser.uid;
      _loggedUserEmail= loggedUser.email;
    });
  }

  @override
  void initState() {
    super.initState();

    _retriveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _retriveContacts(),
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {

                List<User> itemList = snapshot.data;
                User user = itemList[index];

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
                    backgroundImage: user.imageUrl != null
                      ? NetworkImage(user.imageUrl)
                      : null,
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
            break;
        }
        return Container();
      }
    );
  }
}
