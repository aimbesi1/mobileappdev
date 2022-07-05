import '../forms/commentform.dart';
import '../model/comment.dart';
import '../model/post.dart';
import '../pages/authentication.dart';
import '../pages/home.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'profile.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key, required this.originalPost}) : super(key: key);

  final Post originalPost;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Comments")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCommentField,
        child: const Icon(Icons.post_add),
      ),
      body: StreamBuilder<List<Comment>>(
          stream: _fs.comment,
          builder:
              (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred while loading comments"),
              );
            } else if (snapshot.hasData) {
              var comments = snapshot.data!;

              // Only show comments whose IDs match the viewed post
              var filterpost = [];
              for (var element in comments) {
                if (element.threadID == widget.originalPost.id) {
                  filterpost.add(element);
                }
              }
              return filterpost.isEmpty
                  ? const Center(child: Text("No comments yet"))
                  : ListView.builder(
                      itemCount: filterpost.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                            title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile(
                                              observedUser:
                                                  FirestoreService.userMap[
                                                      filterpost[index]
                                                          .authorID]!)));
                                },
                                child: Text(FirestoreService
                                    .userMap[filterpost[index].authorID]!
                                    .name)),
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

  void _showCommentField() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CommentForm(originalPost: widget.originalPost)));
  }
}
