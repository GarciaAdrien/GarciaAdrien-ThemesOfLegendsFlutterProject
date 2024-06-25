import 'dart:async';
import 'dart:math';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AnimatedCountdownCircle extends StatelessWidget {
  final int totalSeconds;
  final int currentSecond;

  AnimatedCountdownCircle(
      {required this.totalSeconds, required this.currentSecond});

  @override
  Widget build(BuildContext context) {
    double progress = currentSecond / totalSeconds;
    Color circleColor = currentSecond <= 5
        ? Colors.red
        : (currentSecond <= 10 ? Colors.green : AppColors.colorTextTitle);

    return CustomPaint(
      painter: CirclePainter(progress, circleColor),
      child: Container(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            '$currentSecond',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  double progress;
  Color color;

  CirclePainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -0.5 * pi,
        2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
