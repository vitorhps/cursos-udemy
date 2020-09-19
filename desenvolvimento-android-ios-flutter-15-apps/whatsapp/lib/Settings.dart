import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController _nameController = TextEditingController();
  File _image;
  String _loggedUserId;
  bool _sendingImage = false;
  String _imageUrl;

  Future _retriveImage(String imageOrigin) async {
    File image;
    if (imageOrigin == "camera") {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;

      if (_image != null) {
        _sendingImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference mainFolder = storage.ref();
    StorageReference file = mainFolder
      .child("profile")
      .child("$_loggedUserId.jpg");

    StorageUploadTask task = file.putFile(_image);

    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _sendingImage = true;
        });
      } else if(storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _sendingImage = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _retriveImageUrl(snapshot);
    });
  }

  Future _retriveImageUrl(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _updateFirestoreImageUrl(url);

    setState(() {
      _imageUrl = url;
    });
  }

  _retriveUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();

    setState(() {
      _loggedUserId = loggedUser.uid;
    });

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("users")
      .document(_loggedUserId)
      .get();

    Map<String, dynamic> data = snapshot.data;
    _nameController.text = data["name"];

    if (data["imageUrl"] != null) {
      setState(() {
        _imageUrl = data["imageUrl"];
      });
    }
  }

  _updateFirestoreName() {
    String name = _nameController.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> data = {
      "name": name,
    };

    db.collection("users")
      .document(_loggedUserId)
      .updateData(data);
  }

  _updateFirestoreImageUrl(String url) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> data = {
      "imageUrl": url,
    };

    db.collection("users")
      .document(_loggedUserId)
      .updateData(data);
  }

  @override
  void initState() {
    super.initState();

    _retriveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: _sendingImage
                    ? CircularProgressIndicator()
                    : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: _imageUrl != null
                    ? NetworkImage(_imageUrl)
                    : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: () => _retriveImage("camera"),
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: () => _retriveImage("galery"),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: _updateFirestoreName,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
