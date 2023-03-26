import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/picture.dart';

class ImageRepoImpl {
  final db = FirebaseFirestore.instance;

  void addPicture({
    required String userUid,
    required File file,
  }) async {
    final size = getFileSize(file);
    final name = file.path.split('/').last;
    print('size: $size, name: $name, path: ${file.path}');

    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child('images/$name');
    final snap = await imagesRef.putFile(file);
    final urlFile = await snap.ref.getDownloadURL();


    print('urlFile: $urlFile');
    print('file link: ${imagesRef.child('images/$name')}');

    final docRef = db.collection('images').doc();

    Picture picture = Picture(
      name: name,
      url: urlFile,
      size: size,
      userUid: userUid
        );
    await docRef.set(picture.toJson()).then(
            (value) => print('iamage create successfully!'),
        onError: (e) => print('Error in create image: $e'));
  }

  static String getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    double kb = sizeInMb * 1024;
    return kb.toStringAsFixed(2);
  }

  void deletePicture(String filename, String imageId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('images/$filename');
    await imageRef.delete();
    await db.collection('images').doc(imageId).delete();
  }
}
