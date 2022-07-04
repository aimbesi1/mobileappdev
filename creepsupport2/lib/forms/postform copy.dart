import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creepsupport2/model/post.dart';

import '../pages/home.dart';
import '../style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: Form(
              key: _formKey,
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
                          postContent(context);
                        });
                      },
                      child: const Text("Post")),
                ],
              ),
            ),
          );
  }

  void postContent(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _db.collection("posts").add(Post(
              id: "",
              content: _content.text,
              createdAt: Timestamp.now(),
              authorID: _auth.currentUser!.uid,
              imageURL: "")
          .toJSON());
    }

    Navigator.of(context).pop();
  }
}
