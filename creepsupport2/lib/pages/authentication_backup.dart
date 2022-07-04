import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style/style.dart';
import '../widgets/loading.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<Authentication> createState() => _AuthState();
}

class _AuthState extends State<Authentication> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authentication Basics"),
        ),
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
                      return "Password is too short";
                    }
                    return null;
                  },
                ),
                OutlinedButton(onPressed: login, child: const Text("LOGIN")),
                OutlinedButton(
                    onPressed: register, child: const Text("REGISTER")),
                OutlinedButton(
                    onPressed: () {}, child: const Text("FORGOT PASSWORD")),
              ],
            )));
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential registerResponse =
            await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);

        setState(() {
          snackBar(context, "Registered successfully");
          loading = false;
        });
      } catch (e) {
        // Include error messages
        setState(() {
          snackBar(context, e.toString());
          loading = true;
        });
      }
    }
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      _auth
          .signInWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .whenComplete(() => setState(() {
                snackBar(context, "Logged in successfully");
                loading = false;
                _password.clear();
              }));
      setState(() {
        loading = true;
      });
    }
  }
}
