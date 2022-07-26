import 'package:cloud_firestore/cloud_firestore.dart';
import '../forms/loginform.dart';
import '../pages/home.dart';
import '../style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This class is designed to handle cases where the user credential is made from an external
// account like Twitter. After logging in, you must fill out every required credential for the
// Firestore database.
class ExternalAuth extends StatefulWidget {
  const ExternalAuth({Key? key}) : super(key: key);

  // final UserCredential externalUser;

  @override
  State<ExternalAuth> createState() => _ExternalAuthState();
}

class _ExternalAuthState extends State<ExternalAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var id = _auth.currentUser?.uid;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _fname,
              decoration: inputStyling("First Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required field";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lname,
              decoration: inputStyling("Last Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required field";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _bio,
              decoration: inputStyling("Biography"),
              validator: (value) {
                return null;
              },
            ),
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    register();
                  });
                },
                child: const Text("REGISTER")),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        _db.collection("users").doc(_auth.currentUser!.uid).set({
          "name": _fname.text,
          "lname": _lname.text,
          "bio": _bio.text,
          "role": "Customer",
          "date": Timestamp.now()
        });

        setState(() {
          loading = false;
          Navigator.pushReplacementNamed(context, '/home');
        });
      } catch (e) {
        setState(() {
          snackBar(context, e.toString());
          loading = false;
        });
      }
    }
  }

  void showLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => const LoginForm()),
    );
  }
}
