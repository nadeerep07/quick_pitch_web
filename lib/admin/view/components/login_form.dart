import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickpitch_wwwweb/core/config/app_button.dart';

import 'package:provider/provider.dart';
import '../../viewmodel/admin_login_viewmodel.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AdminLoginViewModel>(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Admin Login",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        TextFormField(
          controller: vm.emailController,
          decoration: const InputDecoration(
            hint: Text('Email'),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: vm.passwordController,
          obscureText: !vm.showPassword,
          decoration: const InputDecoration(
            hint: Text('Password'),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: vm.showPassword,
              onChanged: (_) => vm.togglePasswordVisibility(),
            ),
            const Text('show password'),
          ],
        ),

        if (vm.error != null)
          Text(
            'Unauthorized: This is not an admin account',
            style: const TextStyle(color: Colors.red),
          ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 48,
          child:
              vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                    text: 'Login',
                    onPressed: () async {
                      final success = await vm.loginAdmin();

                      if (success && mounted) {
                      context.go('/admin/dashboard');

                      }
                    },
                  ),
        ),
      ],
    );
  }
}
