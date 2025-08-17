// lib/admin/viewmodel/admin_login_viewmodel.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? error;
   bool showPassword = false;

  Future<bool> loginAdmin() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;
      const adminUID = '6HVQ1ynHRTMyA60iLHBMxSYdyuI3';

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid != adminUID) {
        error = 'Unauthorized: This is not an admin account';
        FirebaseAuth.instance.signOut();
        notifyListeners();
        return false;
      }
      isLoading = false;
    notifyListeners();
    return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Login failed';
    } catch (e) {
      error = 'Something went wrong';
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logoutAdmin() async {
  try {
    await FirebaseAuth.instance.signOut();
    emailController.clear();
    passwordController.clear();
  } catch (e) {
    error = 'Logout failed';
    notifyListeners();
  }
}

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
