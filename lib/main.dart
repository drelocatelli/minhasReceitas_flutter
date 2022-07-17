import 'package:flutter/material.dart';
import 'package:myrecipes/View/Home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      useMaterial3: false
    ),
    debugShowCheckedModeBanner: false,
  ));
}
