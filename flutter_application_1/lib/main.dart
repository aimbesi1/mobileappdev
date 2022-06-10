import 'package:flutter/material.dart';

void main() {
  runApp(const _WidgetTestApp());
}

class _WidgetTestApp extends StatelessWidget {
  const _WidgetTestApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Our Widget Tester",
             style: TextStyle(
               color: Color.fromARGB(255, 255, 155, 0)
             ),
            ),
          ),
        ),
        body: Container(
          color: Colors.red,
        )
      )
    );
  }
}