import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/home.dart';
import '../services/firestore_service.dart';
import '../style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';
import 'externalauth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: inputStyling("Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email cannot be empty";
                      }
                      if (!value.contains('@')) {
                        return "Email in wrong format";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: inputStyling("Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 7) {
                        return "Password too short.";
                      }
                      return null;
                    },
                  ),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          login(context);
                        });
                      },
                      child: const Text("LOGIN")),
                  OutlinedButton(
                      onPressed: () {
                        forgot();
                      },
                      child: const Text("Forgot Password??")),
                  OutlinedButton(
                      onPressed: () {
                        goBack();
                      },
                      child: const Text("Register new account"))
                ],
              ),
            ),
          );
  }

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential loginResponse = await _auth.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);

        setState(() {
          Navigator.popAndPushNamed(context, '/home');

          loading = false;
        });
      } catch (e) {
        setState(() {
          snackBar(context, e.toString());
          loading = false;
        });
      }
    }
  }

  Future<void> forgot() async {
    if (_email.text.isNotEmpty) {
      _auth.sendPasswordResetEmail(email: _email.text);
      snackBar(context, "Password reset sent to email.");
    } else {
      snackBar(context, "Please input a valid email.");
    }
  }

  void goBack() {
    Navigator.pop(context);
  }
}
