import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String name;
  final String bio;
  final Timestamp date;
  final Map<String, dynamic> conversations;
  String? imageURL;

  User(
      {required this.id,
      required this.username,
      required this.name,
      required this.bio,
      required this.date,
      required this.conversations,
      this.imageURL});

  factory User.fromJson(String id, Map<String, dynamic> data) {
    return User(
        id: id,
        username: data["username"],
        name: data["name"],
        bio: data["bio"],
        date: data["date"],
        conversations: data["conversations"] ?? {},
        imageURL: data["imageURL"] ?? "");
  }

  Map<String, dynamic> toJSON() {
    return {
      "username": username,
      "name": name,
      "bio": bio,
      "date": date,
      "conversations": conversations,
      "imageURL": imageURL
    };
  }
}
