import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/post.dart';
import '../model/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Map<String, User> userMap = {};
  static Map<String, Post> postMap = {};

  final usersCollection = FirebaseFirestore.instance.collection("users");
  final postsCollection = FirebaseFirestore.instance.collection("posts");

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();
  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();

  Stream<Map<String, User>> get users => _usersController.stream;
  Stream<List<Post>> get post => _postsController.stream;

  FirestoreService() {
    _db.collection("users").snapshots().listen(_usersUpdated);
    _db.collection("posts").snapshots().listen(_postsUpdated);
  }

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    Map<String, User> user = _getUserFromSnapshot(snapshot);
    _usersController.add(user);
    print("Added: $user");
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = _getPostFromSnapshot(snapshot);
    _postsController.add(posts);
    print("Added: $posts");
  }

  Map<String, User> _getUserFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var doc in snapshot.docs) {
      User user = User.fromJson(doc.id, doc.data());
      userMap[user.id] = user;
    }

    return userMap;
  }

  List<Post> _getPostFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = [];
    for (var doc in snapshot.docs) {
      Post post = Post.fromJson(doc.id, doc.data());
      posts.add(post);
      postMap[post.id] = post;
    }

    return posts;
  }

  Future<bool> addUser(String userId, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(userId).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPost(Map<String, dynamic> data) async {
    data["createdAt"] = Timestamp.now();
    try {
      await postsCollection.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
