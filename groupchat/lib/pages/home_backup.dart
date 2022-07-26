// import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../forms/postform.dart';
// import '../model/post.dart';
// import '../model/user.dart' as m;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomeState();
// }

// class _HomeState extends State<HomePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   late final Stream<QuerySnapshot> _postStream =
//       _db.collection("posts").snapshots();

//   final List<Post> _posts = [];
//   final List<m.User> users = [];

// // Stream
// // Future
//   @override
//   void initState() {
//     super.initState();
//     // getList();
//     getStreamList();

//     print("initState finished");
//   }

//   void getStreamList() {
//     _db.collection("users").snapshots().listen((snapshots) {
//       for (var element in snapshots.docs) {
//         setState(() {
//           users.add(m.User.fromJson(element.id, element.data()));
//         });
//       }
//     });
//     print("GetStreamList finished");
//   }

//   void getList() {
//     _db.collection("users").get().then((result) {
//       setState(() {
//         for (var element in result.docs) {
//           users.add(element.data()["name"]);
//         }
//       });
//     });
//     print("GetList finished");
//   }

//   void getList2() async {
//     var result = await _db.collection("users").get();
//     for (var element in result.docs) {
//       users.add(element.data()["name"]);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("WELCOME TO 'CREEPSUPPORT2'"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showPostField,
//         child: const Icon(Icons.post_add),
//       ),
//       body: StreamBuilder(
//           stream: _postStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text("Error occurred while loading posts"),
//               );
//             } else if (snapshot.hasData) {
//               for (var post in snapshot.data!.docs) {
//                 _posts.add(Post.fromJson(
//                     post.id, post.data() as Map<String, dynamic>));
//               }
//               if (_posts.isNotEmpty) {
//                 return ListView.builder(
//                   itemCount: _posts.length,
//                   itemBuilder: ((BuildContext context, int index) =>
//                       ListTile(title: Text(_posts[index].content))),
//                 );
//               } else {
//                 return const Center(child: Text("No posts yet"));
//               }
//             } else {
//               return const Center(child: Text("No data yet"));
//             }
//           }),
//     );
//     // ListView.builder(
//     //     itemCount: users.length,
//     //     itemBuilder: (BuildContext context, int index) {
//     //       return ListTile(
//     //         title: Text(users[index].name),
//     //         subtitle: Text(users[index].bio),
//     //       );
//     //     }));
//   }

//   void _showPostField() {
//     showModalBottomSheet<void>(
//         context: context,
//         builder: (context) {
//           return const PostForm();
//         });
//   }
// }
