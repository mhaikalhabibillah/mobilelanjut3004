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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Container(
              width: 200,
              height: 20,
              color:Colors.green,
            ),
           Container(
              width: 150,
              height: 20,
              color:const Color.fromARGB(255, 233, 240, 5),
            ) ,
            Container(
              width: 100,
              height: 20,
              color:const Color.fromARGB(255, 7, 35, 172),
            ),
            Container(
              width: 75,
              height: 20,
              color:const Color.fromARGB(255, 232, 17, 167),
            )
          ],
        )
        
      ),
     
      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
