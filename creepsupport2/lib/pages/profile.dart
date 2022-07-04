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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.observedUser.name)),
      body: Center(
        child: Text(widget.observedUser.bio),
      ),
    );
  }
}
