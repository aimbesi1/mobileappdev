import 'package:groupchat/model/message.dart';
import 'package:intl/intl.dart';

import '../forms/convoform.dart';
import '../model/conversation.dart';

import '../forms/registerform.dart';

import '../model/post.dart';
import '../model/user.dart';
import '../pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

//import '../model/user.dart' as m;
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';

import 'chatpage.dart';

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
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Profile(observedUser: _fs.getUser())));
          },
          child: Row(children: [
            // CircleAvatar(
            //   backgroundColor: Colors.grey,
            //   backgroundImage: AssetImage('images/profile.png'),
            //   // child: Text(_fs.getUsername().toUpperCase().substring(0, 1))
            // ),
            Container(
                padding: const EdgeInsets.only(left: 15),
                child: const Text("Your Group Chats'")),
          ]),
        ),
        actions: [
          IconButton(
            onPressed: _createConvo,
            icon: const Icon(Icons.add),
          ),
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
      body: StreamBuilder<List<Conversation>>(
          stream: _fs.conversation,
          builder: (BuildContext context,
              AsyncSnapshot<List<Conversation>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred while loading posts"),
              );
            } else if (snapshot.hasData) {
              var convos = snapshot.data!;
              var filtered = [];
              for (var convo in convos) {
                if (convo.userIDs.contains(_auth.currentUser?.uid)) {
                  filtered.add(convo);
                }
              }
              return filtered.isEmpty
                  ? const Center(child: Text("No conversations yet"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            title: Text(getUsersFromConvo(filtered[index])),
                            subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(previewText(FirestoreService.messageMap[
                                      filtered[index].lastMessage])),
                                  const SizedBox(height: 10),
                                  Text(FirestoreService.messageMap[
                                              filtered[index].lastMessage] !=
                                          null
                                      ? DateFormat.Md().add_jm().format(
                                          FirestoreService
                                              .messageMap[
                                                  filtered[index].lastMessage]!
                                              .timestamp
                                              .toDate())
                                      : "")
                                ]),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          conversation: filtered[index],
                                          name: getUsersFromConvo(
                                              filtered[index]))));
                            });
                      });
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

  void _createConvo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const ConvoForm()));
  }

  void logout() async {
    await _auth.signOut().then((value) => setState(() {
          Navigator.popAndPushNamed(context, '/');
          // Navigator.pushNamed(context, '/register');
        }));
  }

  String getUsersFromConvo(Conversation convo) {
    var result = "";

    for (var user in convo.userIDs) {
      if (user != _auth.currentUser!.uid) {
        if (result.isEmpty) {
          var map = FirestoreService.userMap;
          result = FirestoreService.userMap[user]!.name;
        } else {
          result += ", ${FirestoreService.userMap[user]!.name}";
        }
      }
    }

    return result;
  }

  String previewText(Message? msg) {
    if (msg == null) {
      return "New conversation";
    } else if (msg.content == "" && msg.imageURL.isNotEmpty) {
      return "Image";
    } else {
      return msg.content;
    }
  }
}
