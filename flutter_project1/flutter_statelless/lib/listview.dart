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
        body: ListView(
         scrollDirection: Axis.vertical,
          
          children: [
            Container(
              width: 300,
              height: 300,
              color:const Color.fromARGB(255, 255, 23, 23),
            ),
           Container(
              width: 300,
              height: 300,
              color:const Color.fromARGB(255, 233, 240, 5),
            ) ,
            Container(
              width: 300,
              height: 300,
              color:const Color.fromARGB(255, 7, 172, 37),
            ),
            Container(
              width: 300,
              height: 300,
              color:const Color.fromARGB(255, 17, 200, 232),
            )
          ],
        )
        
      ),
     
      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
