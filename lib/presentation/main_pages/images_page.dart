import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth2/data/repositories_impl/image_repo_impl.dart';
import 'package:firebase_auth2/presentation/di/app_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesPage extends StatelessWidget {
  ImagesPage({Key? key}) : super(key: key);

  final CollectionReference _images =
      FirebaseFirestore.instance.collection('images');

  @override
  Widget build(BuildContext context) {
    final queryStream = _images
        .where('userUid',
            isEqualTo: AppModule.getProfileHolder().profile.authUid)
        .snapshots();

    return StreamBuilder(
      stream: queryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'У вас еще нет картинок',
                  style: TextStyle(fontSize: 26),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  pickImage();
                },
                child: const Icon(Icons.add),
              )
            ],
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: const Text('Картинки'),
                actions: [
                  IconButton(
                      onPressed: () {
                        pickImage();
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 140,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Card(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ImageRepoImpl().deletePicture(
                                        documentSnapshot['name'],
                                        documentSnapshot.id);
                                  },
                                  icon: const Icon(Icons.delete_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Image.network(documentSnapshot['url']),
                            const SizedBox(height: 10),
                            Text(documentSnapshot['name']),
                            const SizedBox(height: 10),
                            Text('Размер: ${documentSnapshot['size']} Кб'),
                            const SizedBox(height: 10),
                            Text('Url: ${documentSnapshot['url']}'),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  void pickImage() async {
    final PickedFile? result =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (result == null) return;
    final file = File(result.path);
    ImageRepoImpl().addPicture(
        userUid: AppModule.getProfileHolder().profile.authUid, file: file);
  }
}
