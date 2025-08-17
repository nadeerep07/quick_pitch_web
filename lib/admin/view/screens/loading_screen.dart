import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/auth_view_model.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/dashboard_screen.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/login_screen.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    if (authVM.currentUser == null && !authVM.isLoggedIn) {
      return const LoginScreen();
    } else {
      return const DashboardScreen();
    }
  }
}
