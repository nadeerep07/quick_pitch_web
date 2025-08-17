import 'package:go_router/go_router.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/admin_home_screen.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/loading_screen.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/login_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/loading',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/admin/dashboard',
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/admin',
        redirect: (context, state) => '/admin/dashboard',
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminHomeScreen(initialPage: 'dashboard'),
      ),
      GoRoute(
        path: '/admin/skills',
        builder: (context, state) => const AdminHomeScreen(initialPage: 'skills'),
      ),
      GoRoute(
        path: '/admin/certificates',
        builder: (context, state) => const AdminHomeScreen(initialPage: 'certificates'),
      ),
      GoRoute(
        path: '/admin/help-feedback',
        builder: (context, state) => const AdminHomeScreen(initialPage: 'help-feedback'),
      ),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}