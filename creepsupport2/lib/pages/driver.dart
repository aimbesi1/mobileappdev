import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../forms/registerform.dart';
import 'home.dart';

class Driver extends StatelessWidget {
  Driver({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Begin modified code from https://github.com/chustruth/fanpage/blob/main/lib/driver.dart
    _auth.idTokenChanges().listen((event) {});
    if (_auth.currentUser != null) {
      return const HomePage();
    } else {
      return const RegisterForm();
    }
    // End modified code from https://github.com/chustruth/fanpage/blob/main/lib/driver.dart
  }
}
