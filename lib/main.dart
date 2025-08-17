import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/admin_login_viewmodel.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/auth_view_model.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/skill_viewmodel.dart';
import 'package:quickpitch_wwwweb/core/routes/app_routes.dart';
import 'core/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AdminLoginViewModel()),
        ChangeNotifierProvider(create: (_) => SkillViewModel()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Admin Dashboard',
        routerConfig: AppRoutes.router, // Use GoRouter instead
        // Remove home and onGenerateRoute, use router instead
      ),
    );
  }
}