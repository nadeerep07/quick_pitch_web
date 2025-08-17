import 'package:flutter/material.dart';

class AdminPanelBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base background gradient
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.blue.shade50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);

    // Top curve
    final topCurve = Paint()..color = Colors.blue.shade100.withValues(alpha: .5);
    final path1 = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.05, size.width, size.height * 0.15)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path1, topCurve);

    // Bottom wave
    final bottomWave = Paint()..color = Colors.blue.shade100.withValues(alpha: .3);
    final path2 = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.85, size.width, size.height * 0.95)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path2, bottomWave);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
