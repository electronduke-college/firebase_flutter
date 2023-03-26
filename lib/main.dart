import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth2/presentation/di/app_module.dart';
import 'package:firebase_auth2/presentation/home_page.dart';
import 'package:firebase_auth2/presentation/login_page.dart';
import 'package:firebase_auth2/presentation/phone_page.dart';
import 'package:firebase_auth2/presentation/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  print('-- main');
  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  AppModule().provideDependencies();

  print('-- main: Firebase.initializeApp');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/HomePage' : (context) => HomePage(),
        '/SignUpPage' : (context) => SignUpPage(),
        '/PhonePage' : (context) => PhonePage(),
      },
    );
  }
}
