import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? id;
  String? chatId;
  String? senderId;
  String? text;
  Timestamp? timestamp;
  bool? read;

  MessageModel({
    this.id,
    this.chatId,
    this.senderId,
    this.text,
    this.timestamp,
    this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'read': read,
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        chatId = map['chatId'],
        senderId = map['senderId'],
        text = map['text'],
        timestamp = map['timestamp'],
        read = map['read'];
}
