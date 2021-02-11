import 'package:flutter/material.dart';
import 'package:applicationblog/homePage.dart';
import 'package:applicationblog/login.dart';
import 'Mapping.dart';
import 'Auth.dart';
void main()
{
  runApp(
    new MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MappingPage(auth: Auth(),),
    );
  }
}


