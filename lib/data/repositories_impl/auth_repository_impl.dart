import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth2/domain/repositories/auth_repository.dart';
import 'package:firebase_auth2/presentation/di/app_module.dart';

import '../models/profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  final db = FirebaseFirestore.instance;

  @override
  Future<void> anonymousAuth() {
    // TODO: implement anonymousAuth
    throw UnimplementedError();
  }

  @override
  Future<Profile?> signWithEmailAndPassword(
      String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
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
      print('data: ${data}');
      print('dataUser: ${Profile.fromJson(data)}');
      return Profile.fromJson(data);
    });
    return await null;
  }

  @override
  Future<Map<String, dynamic>> signUp(
      {required String email,
      required String password,
      required String surname,
      required String name}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final credential = await auth.createUserWithEmailAndPassword(
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

    Map<String, dynamic> data = <String, dynamic>{};
    db.collection('user').doc(uid).get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
    });
    print(data);
    AppModule.getProfileHolder().profile = Profile.fromJson(data);

    return data;
  }
}
