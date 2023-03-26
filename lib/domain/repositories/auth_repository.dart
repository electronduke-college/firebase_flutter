import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth2/data/models/profile.dart';

abstract class AuthRepository{
  Future<Profile?> signWithEmailAndPassword(String email, String password);
  Future<void> anonymousAuth();
  Future<Map<String, dynamic>> signUp({required String email, required String password, required String surname, required String name});
  //Future<User> signWithEmailLink(String email);
}