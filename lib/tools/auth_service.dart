import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/imports/imports.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential> login(String email, String password) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChanges => auth.authStateChanges();
}
