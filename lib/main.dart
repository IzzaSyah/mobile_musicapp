import 'package:flutter/material.dart';
import 'intro_page.dart';
// import 'home_page.dart';
// import 'player_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: IntroPage(),
    );
  }
}
