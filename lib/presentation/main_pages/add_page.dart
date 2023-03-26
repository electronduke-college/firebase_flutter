import 'package:flutter/material.dart';

import '../../data/repositories_impl/car_repo_impl.dart';

class AddPage extends StatelessWidget {
  AddPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _markController =
      TextEditingController(text: 'Toyota');
  final TextEditingController _modelController =
      TextEditingController(text: 'Camry');
  final TextEditingController _engineController =
      TextEditingController(text: '3.5');
  final TextEditingController _horsepowerController =
      TextEditingController(text: '250');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              const Text(
                'Добавление авто',
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
                  onPressed: () {
                    if (_key.currentState?.validate() ?? false) {
                      CarRepoImpl().addCar(
                        mark: _markController.value.text,
                        model: _modelController.value.text,
                        engineCapacity:
                            double.parse(_engineController.value.text),
                        horsepower: int.parse(_horsepowerController.value.text),
                      );
                    }
                  },
                  child: const Text('Добавить')),
            ],
          ),
        ),
      ),
    );
  }
}
