import 'package:flutter/material.dart';
import 'package:skribble_clone/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skribble clone',
      theme: ThemeData(
        fontFamily: "Mulish",
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
