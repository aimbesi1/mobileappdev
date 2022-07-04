import 'package:creepsupport2/forms/registerform.dart';

import '../forms/postform.dart';
import '../model/post.dart';
import '../pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

//import '../model/user.dart' as m;
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WELCOME TO 'CREEPSUPPORT2'"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                logout();
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPostField,
        child: const Icon(Icons.post_add),
      ),
      body: StreamBuilder<List<Post>>(
          stream: _fs.post,
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred while loading posts"),
              );
            } else if (snapshot.hasData) {
              var posts = snapshot.data!;
              var usr = FirestoreService.userMap;
              // var filterpost = [];
              // for (var element in posts) {
              //   if (element.authorID == "filter") {
              //     filterpost.add(element);
              //   }
              // }
              return posts.isEmpty
                  ? const Center(child: Text("No posts yet"))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                              title: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile(
                                                observedUser: FirestoreService
                                                        .userMap[
                                                    posts[index].authorID]!)));
                                  },
                                  child: Text(FirestoreService
                                      .userMap[posts[index].authorID]!.name)),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(posts[index].content),
                                    const SizedBox(height: 10),
                                    Text(posts[index]
                                        .createdAt
                                        .toDate()
                                        .toString())
                                  ])));
            }
            return const Center(child: Text("No data yet"));
          }),
    );
    // ListView.builder(
    //     itemCount: users.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return ListTile(
    //         title: Text(users[index].name),
    //         subtitle: Text(users[index].bio),
    //       );
    //     }));
  }

  void _showPostField() {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return const PostForm();
        });
  }

  void logout() async {
    await _auth.signOut();
    setState((() {
      Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (BuildContext context) => const RegisterForm()),
      // );
    }));
  }
}
