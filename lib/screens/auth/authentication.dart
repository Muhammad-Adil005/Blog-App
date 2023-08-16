import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to create a new user account
  Future<String?> createAccount(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null; // Return null if success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if an exception occurs
    }
  }

  // Function to login a user through email and password

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Return null if login is successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if an exception occurs
    }
  }

  // This is for checking user has already login or not
  Stream<User?> get onAuthStateChanged =>
      FirebaseAuth.instance.authStateChanges();

  // This function is for signout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
