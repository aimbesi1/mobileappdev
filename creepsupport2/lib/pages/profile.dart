import 'package:creepsupport2/services/firestore_service.dart';

import '../model/post.dart';
import '../pages/authentication.dart';
import '../pages/home.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.observedUser}) : super(key: key);

  final User observedUser;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreService _fs = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text("${widget.observedUser.name}: ${widget.observedUser.bio}")),
      body: StreamBuilder<List<Post>>(
          stream: _fs.post,
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred while loading posts"),
              );
            } else if (snapshot.hasData) {
              var posts = snapshot.data!;

              // Only show posts whose IDs match the viewed post
              var filterpost = [];
              for (var element in posts) {
                if (element.authorID == widget.observedUser.id) {
                  filterpost.add(element);
                }
              }
              return filterpost.isEmpty
                  ? const Center(child: Text("No posts yet"))
                  : ListView.builder(
                      itemCount: filterpost.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                            title: Text(widget.observedUser.name),
                            subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(filterpost[index].content),
                                  const SizedBox(height: 10),
                                ]),
                          ));
            }
            return const Center(child: Text("No data yet"));
          }),
    );
  }
}
