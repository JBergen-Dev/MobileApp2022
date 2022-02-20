import 'package:fanpage_app/database_service.dart';
import 'package:fanpage_app/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  DatabaseService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'John Kush Fan Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:SignInPage(),
    );
  }
}

