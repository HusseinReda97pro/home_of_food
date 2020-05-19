import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';


class CurvePainterBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = pink;
    paint.style = PaintingStyle.fill; // Change this to fill
    var path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(
        -size.width * 0.1, size.height * 0.3, 0, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    // path.lineTo(0,size.height* 0.6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}