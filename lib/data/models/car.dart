class Car {
  final String id;
  final String mark;
  final String model;
  final double engineCapacity;
  final int horsepower;

  Car({
    required this.id,
    required this.mark,
    required this.model,
    required this.engineCapacity,
    required this.horsepower,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        mark: json['mark'],
        model: json['model'],
        engineCapacity: json['engineCapacity'] as double,
        horsepower: json['horsepower'] as int,
        id: json['id']);
  }

  Map<String, dynamic> toJson() => {
        'mark': mark,
        'model': model,
        'engineCapacity': engineCapacity,
        'horsepower': horsepower,
      };
}
