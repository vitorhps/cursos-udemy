import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/Conversation.dart';
import 'package:whatsapp/model/Message.dart';
import 'package:whatsapp/model/User.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  String _loggedUserId;
  String _receiverUserId;
  bool _sendingImage = false;
  Firestore _db = Firestore.instance;
  TextEditingController _messageController = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();

  _sendMessage() {
    String messageText = _messageController.text;

    if (messageText.isNotEmpty) {
      Message message = Message();
      message.userId   = _loggedUserId;
      message.message  = messageText;
      message.imageUrl = "";
      message.type     = "text";

      _saveMessage(_loggedUserId, _receiverUserId, message);
      _saveMessage(_receiverUserId, _loggedUserId, message);

      _saveConversation(message);
    }
  }

  _saveMessage(String senderId, String receiverId, Message message) async {
    await _db.collection("messages")
      .document(senderId)
      .collection(receiverId)
      .document(DateTime.now().millisecondsSinceEpoch.toString())
      .setData(message.toMap());

    _messageController.clear();
  }

  _sendPhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference mainFolder = storage.ref();
    StorageReference file = mainFolder
      .child("messages")
      .child(_loggedUserId)
      .child("$imageName.jpg");

    StorageUploadTask task = file.putFile(image);

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

    Message message = Message();
    message.userId = _loggedUserId;
    message.message = "";
    message.imageUrl= url;
    message.type = "image";

    _saveMessage(_loggedUserId, _receiverUserId, message);
    _saveMessage(_receiverUserId, _loggedUserId, message);
  }

  _retriveUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser loggedUser = await auth.currentUser();

    setState(() {
      _loggedUserId = loggedUser.uid;
      _receiverUserId = widget.contact.userId;
    });

    _addMessageListener();
  }

  _saveConversation(Message message) {
    Conversation senderConversation = Conversation();
    senderConversation.sender = _loggedUserId;
    senderConversation.receiver = _receiverUserId;
    senderConversation.message = message.message;
    senderConversation.name = widget.contact.name;
    senderConversation.imageUrl = widget.contact.imageUrl;
    senderConversation.messageType = message.type;
    senderConversation.save();

    Conversation receiverConversation = Conversation();
    receiverConversation.sender = _receiverUserId;
    receiverConversation.receiver = _loggedUserId;
    receiverConversation.message = message.message;
    receiverConversation.name = widget.contact.name;
    receiverConversation.imageUrl = widget.contact.imageUrl;
    receiverConversation.messageType = message.type;
    receiverConversation.save();
  }

  Stream<QuerySnapshot> _addMessageListener() {
    final stream = _db.collection("messages")
      .document(_loggedUserId)
      .collection(_receiverUserId)
      .snapshots();

    stream.listen((data) {
      _controller.add(data);

      Timer(Duration(seconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _retriveUserData();

    Timer(Duration(seconds: 1), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    var messageBox = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _messageController,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 32,
                  ),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  prefixIcon: _sendingImage
                    ? CircularProgressIndicator()
                    : IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _sendPhoto,
                  ),
                ),
              ),
            ),
          ),
          Platform.isIOS
            ? CupertinoButton(
              child: Text("Enviar"),
              onPressed: _sendMessage,
            )
            : FloatingActionButton(
              backgroundColor: Color(0xff075E54),
              child: Icon(Icons.send, color: Colors.white,),
              mini: true,
              onPressed: _sendMessage,
            ),
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados!"),
              );
            }

            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: querySnapshot.documents.length,
                itemBuilder: (context, index) {

                  List<DocumentSnapshot> messages = querySnapshot.documents.toList();
                  DocumentSnapshot message = messages[index];

                  double containerWidth = MediaQuery.of(context).size.width * 0.8;
                  Alignment alignment = Alignment.centerRight;
                  Color color = Color(0xffd2ffa5);

                  if (_loggedUserId != message["userId"]) {
                    alignment = Alignment.centerLeft;
                    color = Colors.white;
                  }

                  return Align(
                    alignment: alignment,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        width: containerWidth,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: message["type"] == "text"
                          ? Text(
                            message["message"],
                            style: TextStyle(fontSize: 18),
                          )
                          : Image.network(message["imageUrl"])
                      ),
                    ),
                  );
                },
              ),
            );
            break;
        }

        return Container();
      },
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contact.imageUrl != null
                ? NetworkImage(widget.contact.imageUrl)
                : null,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contact.name),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                stream,
                messageBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
