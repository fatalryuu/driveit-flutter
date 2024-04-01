import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String name;
  final String description;
  final List<String> images;

  Car({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
  });
}

class CarsService {
  static final CollectionReference _carsCollection =
      FirebaseFirestore.instance.collection('cars');

  CarsService._privateConstructor();

  static Future<List<Car>> getCars() async {
    QuerySnapshot querySnapshot = await _carsCollection.get();
    List<Car> cars = [];
    for (var doc in querySnapshot.docs) {
      Car car = Car(
        id: doc.id,
        name: doc['name'],
        description: doc['description'],
        images: List<String>.from(doc['images'] ?? []),
      );
      cars.add(car);
    }
    return cars;
  }

  static Future<DocumentReference> getCarReferenceById(String id) async {
      final carDoc = await _carsCollection.doc(id).get();
      return carDoc.reference;
  }
}
