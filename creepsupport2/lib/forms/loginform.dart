import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/home.dart';
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
                        setState(() {
                          loading = true;
                          googleLogin(context);
                        });
                      },
                      child: const Text("Log in with Google")),
                  OutlinedButton(
                      onPressed: () {
                        forgot();
                      },
                      child: const Text("Forgot Password??"))
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
          if (loginResponse.user!.emailVerified) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage()));
          } else {
            snackBar(context, "User logged in but email is not verified.");
            loginResponse.user!.sendEmailVerification();
          }
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

  Future<void> googleLogin(BuildContext context) async {
    // Begin code from https://firebase.google.com/docs/auth/flutter/federated-auth
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
            clientId:
                '854124708286-lkkihvq810lsunbctlq8edtivhg5bjh5.apps.googleusercontent.com')
        .signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, log in with the UserCredential
    try {
      UserCredential loginResponse =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // _db
      //     .collection("users")
      //     .doc(loginResponse.user!.uid)
      //     .set({
      //       "name":
      //       "lname":
      //       "bio":
      //       "role": "Customer",
      //       "date": Timestamp.now()
      //     })
      //     .then((value) => snackBar(context,
      //         "User registered successfully. Please check your email to verify this account."))
      //     .catchError((error) => snackBar(context, "FAILED. $error"));
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ExternalAuth(externalUser: loginResponse)),
        );
        loading = false;
      });
    } catch (e) {
      setState(() {
        snackBar(context, e.toString());
        loading = false;
      });
    }
    // End code from https://firebase.google.com/docs/auth/flutter/federated-auth
  }

  Future<void> forgot() async {
    if (_email.text.isNotEmpty) {
      _auth.sendPasswordResetEmail(email: _email.text);
      snackBar(context, "Password reset sent to email.");
    } else {
      snackBar(context, "Please input a valid email.");
    }
  }
}
