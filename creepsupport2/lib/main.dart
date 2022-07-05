import 'package:creepsupport2/forms/externalauth.dart';
import 'package:creepsupport2/forms/registerform.dart';
import 'package:creepsupport2/pages/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/authentication.dart';
import 'pages/home.dart';
import 'widgets/loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({Key? key}) : super(key: key);

  // final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SocialApp',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Driver(),
          '/register': (context) => const RegisterForm(),
          '/home': (context) => const HomePage(),
          '/ext': (context) => const ExternalAuth(),
        });
  }
}
