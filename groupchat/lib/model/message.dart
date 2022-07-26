import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String fromID;
  // final List<String> toID;
  final String conversationID;
  final String content;
  final Timestamp timestamp;
  final int type;
  String imageURL;

  Message(
      {required this.id,
      required this.content,
      required this.timestamp,
      required this.fromID,
      // required this.toID,
      required this.conversationID,
      required this.type,
      required this.imageURL});

  factory Message.fromJson(String id, Map<String, dynamic> data) {
    return Message(
        id: id,
        fromID: data["fromID"],
        // toID: data["toID"],
        conversationID: data["conversationID"],
        content: data["content"],
        timestamp: data["timestamp"],
        type: data["type"],
        imageURL: data["imageURL"] ?? "");
  }

  Map<String, dynamic> toJSON() {
    return {
      "fromID": fromID,
      // "toID": toID,
      "type": type,
      "conversationID": conversationID,
      "content": content,
      "timestamp": timestamp,
      "imageURL": imageURL
    };
  }
}
