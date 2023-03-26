import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/car.dart';

abstract class CarRepository {
  void addCar({
    required String mark,
    required String model,
    required double engineCapacity,
    required int horsepower,
  });

  void deleteCar(String carId);
}
