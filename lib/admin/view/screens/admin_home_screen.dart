import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickpitch_wwwweb/admin/view/components/admin_app_bar.dart';
import 'package:quickpitch_wwwweb/admin/view/components/admin_panel_background_painter.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/certificates_screen.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/dashboard_screen.dart';
import 'package:quickpitch_wwwweb/admin/view/screens/skills_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final String? initialPage;

  const AdminHomeScreen({super.key, this.initialPage});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late String _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _getPageFromUrl() ?? 'dashboard';
  }

  String? _getPageFromUrl() {
    // ignore: deprecated_member_use
    final uri = Uri.parse(WidgetsBinding.instance.window.defaultRouteName);
    final path = uri.path;
    if (path.contains('/admin/dashboard')) return 'dashboard';
    if (path.contains('/admin/skills')) return 'skills';
    if (path.contains('/admin/certificates')) return 'certificates';
    if (path.contains('/admin/help-feedback')) return 'help-feedback';
    return null;
  }

  Widget _getPage(String page) {
    switch (page) {
      case 'skills':
        return const SkillsScreen();
      case 'certificates':
        return const CertificatesScreen();
      case 'help-feedback':
        return const Center(child: Text('Help & Feedback Screen'));
      case 'dashboard':
      default:
        return const DashboardScreen();
    }
  }

  void _navigateToPage(String page) {
    setState(() => _currentPage = page);
    switch (page) {
      case 'dashboard':
        context.go('/admin/dashboard');
        break;
      case 'skills':
        context.go('/admin/skills');
        break;
      case 'certificates':
        context.go('/admin/certificates');
        break;
      case 'help-feedback':
        context.go('/admin/help-feedback');
        break;
      default:
        context.go('/admin/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // so background goes under AppBar
      appBar: AdminAppBar(
        currentPage: _currentPage,
        onNavigate: _navigateToPage,
      ),
      body: Stack(
        children: [
          ///  Background layer
          Positioned.fill(
            child: CustomPaint(
              painter: AdminPanelBackgroundPainter(),
            ),
          ),

          ///  Foreground page content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 60), 
              child: _getPage(_currentPage),
            ),
          ),
        ],
      ),
    );
  }
}
