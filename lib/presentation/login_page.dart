import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth2/domain/repositories/auth_repository.dart';
import 'package:firebase_auth2/domain/services/firestore_service.dart';
import 'package:firebase_auth2/presentation/di/app_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../data/models/profile.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _loginController = TextEditingController(text: 'qqq@mail.ru');

  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      print('Приложение возоблевно');
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
        print('deepLink');
        final Uri deepLink = dynamicLink.link;
        print('deepLink $deepLink');
        handleLink(link: deepLink, userEmail: _loginController.value.text);
        print('handle Ok');
        FirebaseDynamicLinks.instance.onLink.listen((event) async {
          final Uri deepLink = dynamicLink.link;
          print('deepLink2 $deepLink');
          handleLink(link: deepLink, userEmail: _loginController.value.text);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void handleLink({Uri? link, required String userEmail}) async {
    if (link != null) {
      print(userEmail);
      final UserCredential user =
          await FirebaseAuth.instance.signInWithEmailLink(
        email: userEmail,
        emailLink: link.toString(),
      );
      if (user != null) {
        print(user.credential);
      }
    } else {
      print("link is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/gor.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.9,
                    width: width * 0.8,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'Авторизация',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _loginController,
                                validator: (value) {
                                  if (value?.trim().isNotEmpty == true) {
                                    return null;
                                  }
                                  return "Это обязательное поле";
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  labelText: 'Эл. адрес',
                                  prefixIcon: const Icon(Icons.alternate_email),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'example@mail.ru',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value?.trim().isNotEmpty == true) {
                                    return null;
                                  }
                                  return "Это обязательное поле";
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  labelText: 'Пароль',
                                  prefixIcon: const Icon(Icons.password),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Password123',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  print('все ок');
                                  final db = FirebaseFirestore.instance;

                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _loginController.value.text,
                                    password: _passwordController.value.text,
                                  )
                                      .then((value) {
                                    Map<String, dynamic> data = <String, dynamic>{};
                                    db
                                        .collection('user')
                                        .doc(value.user!.uid)
                                        .get()
                                        .then((DocumentSnapshot doc) {
                                      data = doc.data() as Map<String, dynamic>;
                                      print('--DATA: ${doc.data()}');
                                      AppModule.getProfileHolder().profile = Profile.fromJson(data);
                                    });
                                    Navigator.of(context).pushNamed('/HomePage');
                                    print('data: ${data}');
                                    print('dataUser: ${Profile.fromJson(data)}');
                                    return Profile.fromJson(data);
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 25),
                                child: Text(
                                  'Войти',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                FirebaseAuth.instance.signInAnonymously().then(
                                    (value) => Navigator.of(context)
                                        .pushNamed('/HomePage'));
                                //Navigator.of(context).pushNamed('/HomePage');
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 25),
                                child: Text(
                                  'Войти как гость',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/SignUpPage');
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 25),
                                child: Text(
                                  'Регистрация',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signWithLink(String email) async {
    print(email);
    return await _auth
        .sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
            url: 'https://electronduke5.page.link/',
            dynamicLinkDomain: 'electronduke5.page.link',
            handleCodeInApp: true,
            androidPackageName: 'com.example.firebase_auth',
            androidMinimumVersion: '1',
          ),
        )
        .then((value) => print('Email sent'));
  }
}
