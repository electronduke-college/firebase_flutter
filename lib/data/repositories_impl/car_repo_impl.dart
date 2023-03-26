import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth2/data/models/car.dart';
import 'package:firebase_auth2/domain/repositories/car_repository.dart';

class CarRepoImpl implements CarRepository {
  final db = FirebaseFirestore.instance;

  @override
  void addCar(
      {required String mark,
      required String model,
      required double engineCapacity,
      required int horsepower}) async {
    final docRef = db.collection('cars').doc();

    Car car = Car(
        id: docRef.id,
        mark: mark,
        model: model,
        engineCapacity: engineCapacity,
        horsepower: horsepower);
    await docRef.set(car.toJson()).then(
        (value) => print('car create successfully!'),
        onError: (e) => print('Error in create car: $e'));
  }

  @override
  void deleteCar(String carId) async {
    await db.collection('cars').doc(carId).delete();
  }
}
