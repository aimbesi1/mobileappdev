import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creepsupport2/model/post.dart';
import 'package:creepsupport2/model/comment.dart';
import 'package:creepsupport2/services/firestore_service.dart';

import '../pages/home.dart';
import '../style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({Key? key, required this.originalPost}) : super(key: key);

  final Post originalPost;

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();

  final TextEditingController _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _content,
            minLines: 5,
            maxLines: 5,
            decoration: inputStyling("Post something!"),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "You didn't write anything";
              }
              return null;
            },
          ),
          OutlinedButton(
              onPressed: () {
                setState(() {
                  // loading = true;
                  postComment(context);
                });
              },
              child: const Text("Post")),
        ],
      ),
    ));
  }

  void postComment(BuildContext context) {
    _fs.addComment({
      "content": _content.text,
      "threadID": widget.originalPost.id,
      "authorID": _auth.currentUser!.uid,
    }).then((value) => Navigator.of(context).pop());
  }
}
