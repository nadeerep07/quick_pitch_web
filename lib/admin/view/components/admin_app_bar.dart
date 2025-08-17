import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickpitch_wwwweb/admin/view/components/logout_confirmation_dialog.dart';
import 'package:quickpitch_wwwweb/admin/viewmodel/admin_login_viewmodel.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final void Function(String) onNavigate;

  const AdminAppBar({
    super.key,
    required this.currentPage,
    required this.onNavigate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AdminLoginViewModel>(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 24,
      title: Row(
        children: [
          const Icon(Icons.dashboard_customize, color: Colors.black),
          const SizedBox(width: 8),
          Text('QuickPitch', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      actions: [
        _navItem('dashboard', 'Dashboard'),
        _navItem('skills', 'Skills'),
        _navItem('certificates', 'Certificates'),
        _navItem('help-feedback', 'Help & Feedback'),
        const SizedBox(width: 8),
        const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.logout_outlined, color: Colors.black),
          tooltip: 'Logout',
          onPressed: () {
         showDialog(context: context, builder: (_) => LogoutConfirmationDialog(onConfirm: (){
            vm.logoutAdmin();
            context.go('/admin/login'); 
         }));

          },
        ),
      ],
    );
  }

  Widget _navItem(String id, String label) {
    final isSelected = id == currentPage;
    return TextButton(
      onPressed: () => onNavigate(id),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
