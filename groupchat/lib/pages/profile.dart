import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../services/firestore_service.dart';

import '../model/post.dart';
import '../pages/authentication.dart';
import '../pages/home.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.observedUser}) : super(key: key);

  final User observedUser;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreService _fs = FirestoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    double rank = 0;
    if (widget.observedUser.conversations.isNotEmpty) {
      for (var score in widget.observedUser.conversations.values.toList()) {
        rank += score;
      }
      rank /= widget.observedUser.conversations.length;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.observedUser.name}'s profile"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(TextSpan(
              text: widget.observedUser.bio,
              style:
                  const TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
            )),
            // CircleAvatar(
            //     backgroundColor: Colors.white,
            //     backgroundImage: NetworkImage(widget.observedUser.imageURL),
            //     radius: 70.0),
            // Container(
            //     padding: const EdgeInsets.only(top: 15),
            //     child: widget.observedUser.id == _fs.getUserID()
            //         ? OutlinedButton(
            //             child: Icon(Icons.edit),
            //             onPressed: editProfilePicture,
            //           )
            //         : Container()),
            Container(
              padding: const EdgeInsets.all(8.0),
              // height: 200.0,
              child: Center(
                  child: Column(children: [
                const Text("This user's rank is:"),
                Text.rich(
                  TextSpan(
                    // default text style
                    children: <TextSpan>[
                      TextSpan(
                        text: rank.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ])),
            ),
          ],
        ));
  }

  Future<void> editProfilePicture() async {
    final result = await FilePicker.platform.pickFiles();
    final path = 'users/${_fs.getUserID()}/${result!.names[0]}';
    final file = File(path);
    final ref = _storage.ref().child(path);
    ref.putFile(file);
    final url = await ref.getDownloadURL();
    widget.observedUser.imageURL = url;
  }
}
