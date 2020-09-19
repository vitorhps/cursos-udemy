import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Firestore db = Firestore.instance;

  /*
  db.collection("users")
    .document("001")
    .setData({
      "name": "Vitor Hugo",
      "age": 17,
    });
   */

  /*
  DocumentReference ref = await db.collection("notices")
    .add({
      "title": "Criada nova moeda virtual!",
      "description": "Lorem ipsum dolor sit amet...",
    });
  print("Item salvo: ${ref.documentID}");

  db.collection("notices")
    .document(ref.documentID)
    .setData({
      "title": "Criada nova moeda virtual! (alterado)",
      "description": "Lorem ipsum dolor sit amet...",
    });
    */

  /*
  db.collection("users")
    .document("003")
    .delete();
  */


  /*
  DocumentSnapshot snapshot = await db.collection("users")
    .document("001")
    .get();

  print("Dados: ${snapshot.data.toString()}");
  */

  /*
  QuerySnapshot querySnapshot = await db.collection("users")
    .getDocuments();

  for(DocumentSnapshot item in querySnapshot.documents) {
    print("Dados: ${item.data.toString()}");
  }
  */

  /*
  db.collection("users")
    .snapshots()
    .listen((snapshot) {
      for(DocumentSnapshot item in snapshot.documents) {
        print("Dados: ${item.data.toString()}");
      }
    });
  */

  /*
  QuerySnapshot querySnapshot = await db.collection("users")
    // .where("name", isEqualTo: "Vitor Hugo")
    // .where("age", isGreaterThanOrEqualTo: 17)
    .where("age", isLessThan: 20)
    .orderBy("age", descending: false)
    .orderBy("name", descending: false)
    // .limit(2)
    .getDocuments();

  for(DocumentSnapshot item in querySnapshot.documents) {
    print("Dados: ${item.data.toString()}");
  }
  */


  /*
  var search = "Vit";
  QuerySnapshot querySnapshot = await db.collection("users")
    .where("name", isGreaterThanOrEqualTo: search)
    .where("name", isLessThanOrEqualTo: search + "\uf8ff")
    .getDocuments();

  for(DocumentSnapshot item in querySnapshot.documents) {
    print("Dados: ${item.data.toString()}");
  }
  */

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String email = "vitor@gmail.com";
  String password = "123456";

  /*
  firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  ).then((firebaseUser) {
    print("Novo usuário: ${firebaseUser.email}");
  }).catchError((error) {
    print("Erro: ${error.toString()}");
  });
  */

  /*
  FirebaseUser loggedUser = await firebaseAuth.currentUser();
  if (loggedUser != null) {
    print("Usuário logado: ${loggedUser.email}");
  } else {
    print("Usuário não logado");
  }
  */

  // firebaseAuth.signOut();

  /*
  firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  ).then((firebaseUser) {
    print("Usuário Logado: ${firebaseUser.email}");
  }).catchError((error) {
    print("Erro: ${error.toString()}");
  });
  */

  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  File _image;
  String _uploadStatus = "Upload não iniciado";
  String _imageUrl = null;

  Future<File> _retriveImage(bool camera) async {
    File image;
    if (camera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  }

  Future _uploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference mainFolder = firebaseStorage.ref();
    StorageReference file = mainFolder.child("photos").child("photo01.jpg");

    StorageUploadTask storageUploadTask = file.putFile(_image);

    storageUploadTask.events.listen((StorageTaskEvent storageTaskEvent) {
      String uploadStatus = "";
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        uploadStatus = "Em progresso";
      } else if(storageTaskEvent.type == StorageTaskEventType.success) {
        uploadStatus = "Upload r ealizado com sucesso";
      }

      setState(() {
        _uploadStatus = uploadStatus;
      });
    });

    storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot) {
      _retriveImageUrl(snapshot);
    });
  }

  _retriveImageUrl(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    print("Url: $url");

    setState(() {
      _imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar Imagem"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_uploadStatus),
            RaisedButton(
              child: Text("Câmera"),
              onPressed: () => _retriveImage(true),
            ),
            RaisedButton(
              child: Text("Galeria"),
              onPressed: () => _retriveImage(false),
            ),
            _image == null
              ? Container()
              : Image.file(_image),
            _image == null
              ? Container()
              : RaisedButton(
                child: Text("Upload Storage"),
                onPressed: _uploadImage,
              ),
              _imageUrl == null
                ? Container()
                : Image.network(_imageUrl),
          ],
        ),
      ),
    );
  }
}
