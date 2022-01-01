
import 'package:alfarasha/constants.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint=Paint()..color=yellowColor;
    Path path=Path()..relativeLineTo(0, 60)..quadraticBezierTo(size.width/2, 150, size.width, 60)..relativeLineTo(0, -100)..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

}