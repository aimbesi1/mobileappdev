import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final Timestamp createdAt;
  final String authorID;
  final String imageURL;

  Post(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.authorID,
      required this.imageURL});

  factory Post.fromJson(String id, Map<String, dynamic> data) {
    return Post(
        id: id,
        authorID: data["authorID"],
        content: data["content"],
        createdAt: data["createdAt"],
        imageURL: data["imageURL"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "content": content,
      "createdAt": createdAt,
      "authorID": authorID,
      "imageURL": imageURL
    };
  }
}
