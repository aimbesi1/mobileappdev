import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String threadID;
  final String content;
  final Timestamp createdAt;
  final String authorID;

  Comment(
      {required this.id,
      required this.threadID,
      required this.content,
      required this.createdAt,
      required this.authorID});

  factory Comment.fromJson(String id, Map<String, dynamic> data) {
    return Comment(
        id: id,
        threadID: data["threadID"],
        authorID: data["authorID"],
        content: data["content"],
        createdAt: data["createdAt"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "threadID": threadID,
      "createdAt": createdAt,
      "authorID": authorID
    };
  }
}
