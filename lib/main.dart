import 'package:flutter/material.dart';
import 'screens/SignIn.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: loginpage(title: 'Messenger',),
    );
  }
}

