import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creepsupport2/forms/loginform.dart';
import '../style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            TextButton(
                onPressed: showLogin,
                child: const Text("Log in with existing account")),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential registerResponse =
            await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);

        _db
            .collection("users")
            .doc(registerResponse.user!.uid)
            .set({
              "name": _fname.text,
              "lname": _lname.text,
              "bio": _bio.text,
              "role": "Customer",
              "date": Timestamp.now()
            })
            .then((value) => snackBar(context,
                "User registered successfully. Please check your email to verify this account."))
            .catchError((error) => snackBar(context, "FAILED. $error"));

        registerResponse.user!.sendEmailVerification();
        setState(() {
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

  void showLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => const LoginForm()),
    );
  }
}
