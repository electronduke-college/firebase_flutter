import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth2/data/repositories_impl/car_repo_impl.dart';
import 'package:flutter/material.dart';

import '../../data/models/car.dart';

class ViewPage extends StatelessWidget {
  ViewPage({Key? key}) : super(key: key);

  final CollectionReference _cars =
  FirebaseFirestore.instance.collection('cars');
  final TextEditingController _markController =
  TextEditingController(text: 'Mercedes');
  final TextEditingController _modelController =
  TextEditingController(text: 'S 63 AMG');
  final TextEditingController _engineController =
  TextEditingController(text: '3.0');
  final TextEditingController _horsepowerController =
  TextEditingController(text: '350');
  final GlobalKey<FormState> _key = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Future<void> _update(DocumentSnapshot documentSnapshot) async {
      _markController.text = documentSnapshot['mark'];
      _modelController.text = documentSnapshot['model'];
      _engineController.text = documentSnapshot['engineCapacity'].toString();
      _horsepowerController.text = documentSnapshot['horsepower'].toString();

      await showModalBottomSheet(context: context, builder: (BuildContext ctx) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery
                    .of(ctx)
                    .viewInsets
                    .bottom + 20),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Изменение авто',
                    style: TextStyle(fontSize: 24),
                  ),
                  Card(
                    child: TextFormField(
                      controller: _markController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Это обязательное поле";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        labelText: 'Марка',
                        hintText: 'Mercedes',
                      ),
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: _modelController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Это обязательное поле";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        labelText: 'Модель',
                        hintText: 'S 63',
                      ),
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: _engineController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Это обязательное поле";
                        }
                        return null;
                      },
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          labelText: 'Объем двигателя',
                          hintText: '2.5',
                          suffixText: 'л.'),
                    ),
                  ),
                  Card(
                    child: TextFormField(
                      controller: _horsepowerController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Это обязательное поле";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        labelText: 'Лошадиные силы',
                        hintText: '250',
                        suffixText: 'л.с.',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState?.validate() ?? false) {
                          Car car = Car(
                              mark: _markController.value.text,
                              model: _modelController.value.text,
                              engineCapacity:
                              double.parse(_engineController.value.text),
                              horsepower: int.parse(
                                  _horsepowerController.value.text),
                              id: ''
                          );
                          await _cars.doc(documentSnapshot.id).update(car
                              .toJson()).then((value) {
                            _markController.text = '';
                            _modelController.text = '';
                            _engineController.text = '';
                            _horsepowerController.text = '';
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: const Text('Обновить')),
                ],
              ),
            ),
          ),
        );
      });
    }


    return StreamBuilder(
      stream: _cars.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                snapshot.data!.docs[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                        "${documentSnapshot['mark']} ${documentSnapshot['model']}"),
                    subtitle: Text(
                        "Объем: ${documentSnapshot['engineCapacity']} л. ${documentSnapshot['horsepower']} л.с."),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit), onPressed: () {
                            _update(documentSnapshot);
                          }),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  CarRepoImpl()
                                      .deleteCar(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
