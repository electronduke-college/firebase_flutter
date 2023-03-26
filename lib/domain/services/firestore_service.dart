import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService<T extends Object> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<DocumentReference<Map<String, dynamic>>> add(
      {required String collectionPath, required Map<String, dynamic> data}) {
    final model = fireStore.collection(collectionPath);
    return model
        .add(data)
        //.then((value) => print('Successfully added'))
        .catchError((error) => print("Failed adding: $error"));
  }

  Future<void> update({
    required String collectionPath,
    required String document,
    required Map<String, dynamic> data,
  }) {
    final model = fireStore.collection(collectionPath);
    return model
        .doc(document)
        .set(data)
        .then((value) => print('Successfully updating'))
        .catchError((error) => print("Failed updating: $error"));
  }

  Future<void> delete({
    required String collectionPath,
    required String document,
  }) {
    final model = fireStore.collection(collectionPath);
    return model
        .doc(document)
        .delete()
        .then((value) => print('Successfully deleted'))
        .catchError((error) => print("Failed deleting: $error"));
  }

  Future<DocumentSnapshot<dynamic>> get({
    required String collectionPath,
    required String document,
  }) {
    final model = fireStore.collection(collectionPath);
    return model
        .doc(document)
        .get()
        .catchError((error) => print("Failed getting: $error"));
  }
}
