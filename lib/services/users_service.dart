import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driveit/services/cars_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDB {
  final String id;
  final String email;
  String name;
  String surname;
  String username;
  String birthday;
  String job;
  String country;
  String city;
  String education;
  String hobby;
  String social;
  List<DocumentReference> favourites;

  UserDB({
    required this.id,
    required this.email,
    this.name = '',
    this.surname = '',
    this.username = '',
    this.birthday = '',
    this.job = '',
    this.country = '',
    this.city = '',
    this.education = '',
    this.hobby = '',
    this.social = '',
    this.favourites = const [],
  });

  // Convert user data to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'username': username,
      'birthday': birthday,
      'job': job,
      'country': country,
      'city': city,
      'education': education,
      'hobby': hobby,
      'social': social,
      'favourites': favourites.map((fav) => fav.path).toList(),
    };
  }
}

class UsersService {
  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  UsersService._privateConstructor();

  static Future<void> createUser(User? user) async {
    if (user != null) {
      UserDB userDB = UserDB(id: user.uid, email: user.email!);
      await _usersCollection.doc(userDB.id).set(userDB.toMap());
    }
  }

  static Future<UserDB> getUser(String id) async {
    DocumentSnapshot userSnapshot = await _usersCollection.doc(id).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    List<DocumentReference> favourites = List<DocumentReference>.from(userData['favourites'] ?? []);


    return UserDB(
      id: userData['id'],
      email: userData['email'],
      name: userData['name'] ?? '',
      surname: userData['surname'] ?? '',
      username: userData['username'] ?? '',
      birthday: userData['birthday'] ?? '',
      job: userData['job'] ?? '',
      country: userData['country'] ?? '',
      city: userData['city'] ?? '',
      education: userData['education'] ?? '',
      hobby: userData['hobby'] ?? '',
      social: userData['social'] ?? '',
      favourites: favourites,
    );
  }

  static Future<UserDB> updateUser({
    required String id,
    required String name,
    required String surname,
    required String username,
    required String birthday,
    required String job,
    required String country,
    required String city,
    required String education,
    required String hobby,
    required String social,
  }) async {
    await _usersCollection.doc(id).update({
      'name': name,
      'surname': surname,
      'username': username,
      'birthday': birthday,
      'job': job,
      'country': country,
      'city': city,
      'education': education,
      'hobby': hobby,
      'social': social,
    });

    final updatedUser = await getUser(id);
    return updatedUser;
  }

  static Future<void> deleteUser(String id) async {
    await _usersCollection.doc(id).delete();
  }

  static Future<void> addCarToFavourites(String carId) async {
    User user = FirebaseAuth.instance.currentUser!;
    final carRef = await CarsService.getCarReferenceById(carId);
    await _usersCollection.doc(user.uid).update({
      'favourites': FieldValue.arrayUnion([carRef])
    });
  }

  static Future<void> removeCarFromFavourites(String carId) async {
    User user = FirebaseAuth.instance.currentUser!;
    final carRef = await CarsService.getCarReferenceById(carId);
    await _usersCollection.doc(user.uid).update({
      'favourites': FieldValue.arrayRemove([carRef])
    });
  }

  static Future<List<Car>> getCarsFromFavorites() async {
    User user = FirebaseAuth.instance.currentUser!;
    final userDoc = await _usersCollection.doc(user.uid).get();
    final List<DocumentReference> favoriteCarRefs =
    List<DocumentReference>.from(userDoc.get('favourites') ?? []);

    final List<Car> favoriteCars = [];
    await Future.forEach(favoriteCarRefs, (DocumentReference carRef) async {
      final carDoc = await carRef.get();
      if (carDoc.exists) {
        final carData = carDoc.data()! as Map<String, dynamic>;
        final List<String> images = List<String>.from(carData['images'] ?? []);
        final car = Car(
          id: carDoc.id,
          name: carData['name'],
          description: carData['description'],
          images: images,
        );
        favoriteCars.add(car);
      }
    });
    return favoriteCars;
  }

  static Future<bool> isCarInFavorites(String carId) async {
    final List<Car> favoriteCars = await getCarsFromFavorites();
    return favoriteCars.any((car) => car.id == carId);
  }
}
