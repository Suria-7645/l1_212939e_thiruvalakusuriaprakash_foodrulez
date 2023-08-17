import 'package:flutter/material.dart';

import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/home_page.dart';
import 'package:l1_212939e_thiruvalakusuriaprakash_foodrulez/screens/login_page.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Rulez',
      routes: {
        '/login':(context) => LoginPage(),
        '/home':(context) => HomePage(),
      },
      home: LoginPage(),
    );
  }
}
