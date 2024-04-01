import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService._privateConstructor();

  static Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<User?> signUp(String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user.user;
  }

  static void logOut() {
    _auth.signOut();
  }

  static Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }
}
