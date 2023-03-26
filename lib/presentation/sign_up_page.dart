import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth2/presentation/di/app_module.dart';
import 'package:flutter/material.dart';

import '../data/models/profile.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _nameControler = TextEditingController();
  final TextEditingController _surnameControler = TextEditingController();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
                              'Регистрация',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _surnameControler,
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
                                  labelText: 'Фамилия',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Иванов',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _nameControler,
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
                                  labelText: 'Имя',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Иван',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _emailControler,
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
                                  labelText: 'Эл. почта',
                                  prefixIcon: const Icon(Icons.alternate_email),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'example@mail.ru',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _passwordControler,
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
                                  labelText: 'Пароль',
                                  prefixIcon: const Icon(Icons.password),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'password123',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  print('все ок');
                                  final db = FirebaseFirestore.instance;
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;

                                  final email = _emailControler.value.text;
                                  final password =
                                      _passwordControler.value.text;
                                  final surname = _surnameControler.value.text;
                                  final name = _nameControler.value.text;

                                  final credential =
                                      await auth.createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  final uid = credential.user?.uid;
                                  if (uid == null) {
                                    throw Exception('Failed registration');
                                  }

                                  final docRef = db.collection('user').doc(uid);
                                  final profile = await docRef.set({
                                    'authUid': uid,
                                    'email': email,
                                    'password': password,
                                    'surname': surname,
                                    'name': name,
                                  });

                                  Map<String, dynamic> data =
                                      <String, dynamic>{};
                                  db
                                      .collection('user')
                                      .doc(uid)
                                      .get()
                                      .then((DocumentSnapshot doc) {
                                    data = doc.data() as Map<String, dynamic>;
                                    AppModule.getProfileHolder().profile =
                                        Profile.fromJson(data);
                                    Navigator.of(context)
                                        .pushNamed('/HomePage');
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
}
