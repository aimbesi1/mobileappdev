import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../model/user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConvoForm extends StatefulWidget {
  const ConvoForm({Key? key}) : super(key: key);

  @override
  State<ConvoForm> createState() => _ConvoFormState();
}

class _ConvoFormState extends State<ConvoForm> {
  final _fs = FirestoreService();
  List<User> users = FirestoreService.userMap.values.toList();
  List<String> recipients = [];
  final _search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<User> filtered = [];
    for (User element in users) {
      if (element.id != _fs.getUserID() &&
          element.name.toUpperCase().contains(_search.text.toUpperCase())) {
        filtered.add(element);
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Conversation"),
          actions: recipients.isEmpty
              ? []
              : [
                  IconButton(
                      onPressed: createConvo, icon: const Icon(Icons.check))
                ],
        ),
        body: Column(
          children: [
            TextField(
                controller: _search,
                decoration: const InputDecoration(
                  hintText: "Search for users",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                ),
                onChanged: (text) {
                  setState(() {
                    // Repopulate filtered list using the updated search bar text
                    filtered = [];
                    for (User element in users) {
                      if (element.id != _fs.getUserID() &&
                          element.name
                              .toUpperCase()
                              .contains(_search.text.toUpperCase())) {
                        filtered.add(element);
                      }
                    }
                  });
                }),
            ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (BuildContext context, int index) {
                  var added = recipients.contains(filtered[index].id);
                  return ListTile(
                    title: Text(filtered[index].name),
                    trailing: added
                        ? const Icon(
                            Icons.check_box,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.red,
                          ),
                    onTap: () {
                      setState(() {
                        if (added) {
                          recipients.remove(filtered[index].id);
                        } else {
                          recipients.add(filtered[index].id);
                        }
                      });
                    },
                  );
                }),
          ],
        ));
  }

  void createConvo() {
    FirestoreService().addConversation(recipients);
    Navigator.pop(context);
  }
}
