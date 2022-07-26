import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat/model/conversation.dart';
import 'package:groupchat/model/message.dart';
import 'package:intl/intl.dart';

import '../services/firestore_service.dart';

import '../model/post.dart';
import '../pages/authentication.dart';
import '../pages/home.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../style/style.dart';
import 'profile.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.conversation, required this.name})
      : super(key: key);

  final Conversation conversation;
  final String name;

  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _message = TextEditingController();
  final FirestoreService _fs = FirestoreService();
  String imageURL = "";
  @override
  Widget build(BuildContext context) {
    final userMap = FirestoreService.userMap;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "How good is this conversation?",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              RatingBar.builder(
                itemCount: 5,
                allowHalfRating: true,
                initialRating: FirestoreService.userMap[_fs.getUserID()]!
                        .conversations[widget.conversation.id]
                        .toDouble() ??
                    0,
                onRatingUpdate: (value) {
                  var map = FirestoreService.userMap;
                  for (var user in widget.conversation.userIDs) {
                    _fs.addScore(user, widget.conversation, value);
                  }
                  map = FirestoreService.userMap;
                  snackBar(context, "Rating saved");
                },
                itemBuilder: (BuildContext context, int index) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: Text(widget.name), actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        )
      ]),
      body: SafeArea(
        child: Column(children: [_messageArea(context), _inputArea(context)]),
      ),
    );
  }

  Widget _messageArea(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Message>>(
          stream: _fs.message,
          builder:
              (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred while loading messages"),
              );
            } else if (snapshot.hasData) {
              var messages = snapshot.data!;

              // Only show posts that are in the selected conversation
              List<Message> filterpost = [];
              for (var element in messages) {
                if (element.conversationID == widget.conversation.id) {
                  filterpost.add(element);
                }
              }
              filterpost.sort((a, b) =>
                  a.timestamp.toDate().compareTo(b.timestamp.toDate()));

              return filterpost.isEmpty
                  ? const Center(child: Text("No posts yet"))
                  : ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: filterpost.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool currentUser =
                            filterpost[index].fromID == _fs.getUserID();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                        observedUser: FirestoreService.userMap[
                                            filterpost[index].fromID]!)));
                          },
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: currentUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: currentUser
                                          ? EdgeInsets.only(right: 10, top: 10)
                                          : EdgeInsets.only(left: 10, top: 10),
                                      child: Text(
                                        FirestoreService
                                            .userMap[filterpost[index].fromID]!
                                            .name,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontStyle: FontStyle.normal),
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: currentUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        filterpost[index].content.isNotEmpty
                                            ? ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 175),
                                                child: Container(
                                                  // width: 100,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14,
                                                          right: 14,
                                                          top: 7,
                                                          bottom: 7),
                                                  // width: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: currentUser
                                                        ? Colors.red.shade200
                                                        : Colors.white,
                                                  ),
                                                  margin: currentUser
                                                      ? EdgeInsets.only(
                                                          right: 10,
                                                          top: 7,
                                                          bottom: 7)
                                                      : EdgeInsets.only(
                                                          left: 10,
                                                          top: 7,
                                                          bottom: 7),
                                                  child: Text(
                                                    filterpost[index].content,
                                                    // textAlign: currentUser
                                                    //     ? TextAlign.right
                                                    //     : TextAlign.left,
                                                    style: TextStyle(
                                                        color: currentUser
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        filterpost[index].imageURL != ""
                                            ? Image(
                                                height: 100,
                                                width: 100,
                                                image: AssetImage(
                                                    filterpost[index].imageURL))
                                            : Container()
                                      ]),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: currentUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: currentUser
                                          ? EdgeInsets.only(
                                              right: 10, bottom: 10)
                                          : EdgeInsets.only(
                                              left: 10, bottom: 10),
                                      child: Text(
                                        DateFormat.Md().add_jm().format(
                                            filterpost[index]
                                                .timestamp
                                                .toDate()),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontStyle: FontStyle.normal),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
            } else {
              return const Center(
                child: Text("No data yet"),
              );
            }
          }),
    );
  }

  Widget _inputArea(BuildContext context) {
    return SizedBox(
        width: screenWidth(context),
        child: Row(children: [
          const SizedBox(width: 20),
          Expanded(
              child: TextField(controller: _message, minLines: 1, maxLines: 3)),
          IconButton(
              onPressed: _addSticker, icon: const Icon(Icons.insert_emoticon)),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
        ]));
  }

  void sendMessage() {
    if (_message.text.isNotEmpty || imageURL != "") {
      _fs.addMessage(_message.text, widget.conversation, imageURL);
      _message.clear();
    }
  }

  void _addSticker() {
    // imageURL = "";
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  stickerTile(context, "images/dukeThumb.png"),
                  stickerTile(context, "images/dukeWine.png"),
                  stickerTile(context, "images/emojiSchemin.jpg"),
                  stickerTile(context, "images/dukeThink.png"),
                  stickerTile(context, "images/dukeSip.png"),
                  stickerTile(context, "images/dukeSleep.png"),
                  // ElevatedButton(
                  //   onPressed: sendMessage,
                  //   child: const Text("Post"),
                  // )
                ]),
          );
        });
  }

  Widget stickerTile(BuildContext context, String img) {
    bool selected = imageURL == img;
    return Ink.image(
      fit: BoxFit.cover,
      image: AssetImage(img),
      width: 50,
      height: 50,
      child: InkWell(
        onTap: (() => setState(() {
              imageURL = img;
              sendMessage();
              Navigator.pop(context);
            })),
        // child: Align(
        //   alignment: Alignment.bottomLeft,
        //   child: Icon(
        //       selected ? Icons.check_box : Icons.check_box_outline_blank,
        //       color: selected ? Colors.red : Colors.grey),
        // ),
      ),
    );
  }

  void setImageURL(String img) {
    setState(() {
      imageURL = img;
    });
  }
}
