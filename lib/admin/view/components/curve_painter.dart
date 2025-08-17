import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.shade100;

    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.75, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
