import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {

  String _receiver;
  String _sender;
  String _name;
  String _message;
  String _imageUrl;
  String _messageType;

  Conversation();

  save() async {
    Firestore db = Firestore.instance;
    await db.collection("conversations")
      .document(this.sender)
      .collection("last_conversation")
      .document(this.receiver)
      .setData(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "receiver": this.receiver,
      "sender": this.sender,
      "name": this.name,
      "message": this.message,
      "imageUrl": this.imageUrl,
      "messageType": this.messageType,
    };

    return map;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  set message(String value) {
    _message = value;
  }

  String get sender => _sender;

  set sender(String value) {
    _sender = value;
  }

  String get receiver => _receiver;

  set receiver(String value) {
    _receiver = value;
  }

  String get messageType => _messageType;

  set messageType(String value) {
    _messageType = value;
  }

}