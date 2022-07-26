import 'package:flutter/material.dart';

// Colors
const Color primaryColor = Colors.cyan;
const Color primaryDarkColor = Color.fromARGB(255, 20, 68, 74);
const Color primaryLightColor = Color.fromARGB(255, 173, 226, 233);

// Font sizes
const double standardText = 18.0;
const double largeText = 24;

// Dimensions
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

void snackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

InputDecoration inputStyling(String label, {hintText}) {
  return InputDecoration(labelText: label, hintText: hintText);
}
