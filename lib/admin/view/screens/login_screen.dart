import 'package:flutter/material.dart';
import 'package:quickpitch_wwwweb/admin/view/components/login_form.dart';
import 'package:quickpitch_wwwweb/admin/view/components/curve_painter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundPainter(),
          Center(
            child: Container(
              width: size.width * 0.3,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: const LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundPainter extends StatelessWidget {
  const _BackgroundPainter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: CurvePainter(),
    );
  }
}
