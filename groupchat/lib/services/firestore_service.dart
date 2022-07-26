import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:groupchat/model/message.dart';
import '../model/conversation.dart';
import '../model/user.dart';

class FirestoreService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Map<String, User> userMap = {};
  static Map<String, Message> messageMap = {};

  static Map<String, Conversation> conversationMap = {};

  final usersCollection = FirebaseFirestore.instance.collection("users");
  final conversationsCollection =
      FirebaseFirestore.instance.collection("conversations");
  final messagesCollection = FirebaseFirestore.instance.collection("messages");

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();
  final StreamController<List<Conversation>> _conversationsController =
      StreamController<List<Conversation>>();
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>();

  Stream<Map<String, User>> get users => _usersController.stream;
  Stream<List<Conversation>> get conversation =>
      _conversationsController.stream;
  Stream<List<Message>> get message => _messagesController.stream;

  FirestoreService() {
    _db.collection("users").snapshots().listen(_usersUpdated);
    _db.collection("conversations").snapshots().listen(_conversationsUpdated);
    _db.collection("messages").snapshots().listen(_messagesUpdated);
  }

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    Map<String, User> users = _getUserFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _conversationsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = _getConversationsFromSnapshot(snapshot);
    _conversationsController.add(conversations);
    print("Added: $conversations");
  }

  void _messagesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> conversations = _getMessagesFromSnapshot(snapshot);
    _messagesController.add(conversations);
    print("Added: $conversations");
  }

  Map<String, User> _getUserFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    try {
      for (var doc in snapshot.docs) {
        User user = User.fromJson(doc.id, doc.data());
        userMap[user.id] = user;
      }
      return userMap;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  List<Conversation> _getConversationsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = [];
    for (var doc in snapshot.docs) {
      Conversation conversation = Conversation.fromJson(doc.id, doc.data());
      conversations.add(conversation);
      conversationMap[conversation.id] = conversation;
    }

    return conversations;
  }

  List<Message> _getMessagesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = [];
    for (var doc in snapshot.docs) {
      Message message = Message.fromJson(doc.id, doc.data());
      messages.add(message);
      messageMap[message.id] = message;
    }

    return messages;
  }

  Future<bool> addUser(String userId, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(userId).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addConversation(List<String> users) async {
    users.add(_auth.currentUser!.uid);
    try {
      var result = await conversationsCollection.add(
          Conversation(id: "", userIDs: users, timestamp: Timestamp.now())
              .toJSON());
      for (var user in users) {
        // userMap[user]!.conversations[result.id] = 0;
        await usersCollection
            .doc(user)
            .update({'conversations.${result.id}': 0});
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addMessage(
      String content, Conversation convo, String imageURL) async {
    var data = Message(
        id: "",
        content: content,
        type: 0,
        conversationID: convo.id,
        fromID: _auth.currentUser!.uid,
        timestamp: Timestamp.now(),
        imageURL: imageURL);
    try {
      var result = await messagesCollection.add(data.toJSON());
      await conversationsCollection.doc(convo.id).update(Conversation(
              id: convo.id,
              userIDs: convo.userIDs,
              timestamp: convo.timestamp,
              lastMessage: result.id)
          .toJSON());
      // for (var id in messageMap.keys.toList()) {
      //   await messagesCollection.doc(id).update({"imageURL": ""});
      // }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addScore(String userID, Conversation convo, double value) async {
    try {
      var result = await usersCollection
          .doc(userID)
          .update({'conversations.${convo.id}': value});
      return true;
    } catch (e) {
      return false;
    }
  }

  User getUser() {
    var map = userMap;
    var user = _auth.currentUser!.uid;
    return userMap[_auth.currentUser!.uid]!;
  }

  String getUserID() {
    return _auth.currentUser!.uid;
  }

  String getUsername() {
    return userMap[_auth.currentUser!.uid]!.name;
  }
}
