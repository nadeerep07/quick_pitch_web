import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? currentUser;

  AuthViewModel() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    currentUser = _auth.currentUser;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
  
  Future<bool> loginWithEmail(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    currentUser = credential.user;
    notifyListeners();
    return true;
  } catch (e) {
    print("Login error: $e");
    return false;
  }
}


  bool get isLoggedIn => currentUser != null;
}
