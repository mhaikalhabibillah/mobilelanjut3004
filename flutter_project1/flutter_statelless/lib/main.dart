import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("My App"),
        ),
        body: Center(
          child: Text("angku",
          style: TextStyle(
            backgroundColor: Colors.amber,
            color: Colors.white,
            fontSize: 30
          ),),
        ),
      ),
     
      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
