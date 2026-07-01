import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter({required this.dateTime});

  // Gold/copper palette
  static const Color gold = Color(0xFFE8D5B7);
  static const Color goldDim = Color(0xFFA09080);
  static const Color goldBright = Color(0xFFF5E6D3);
  static const Color secondHand = Color(0xFFD4A574);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    final now = dateTime;

    // --- Outer glow ring ---
    _drawGlowRing(canvas, center, radius);

    // --- Main ring ---
    _drawOuterRing(canvas, center, radius);

    // --- Tick marks ---
    _drawTickMarks(canvas, center, radius);

    // --- Hands ---
    final hourAngle = _hourAngle(now);
    final minuteAngle = _minuteAngle(now);
    final secondAngle = _secondAngle(now);

    _drawHourHand(canvas, center, radius, hourAngle);
    _drawMinuteHand(canvas, center, radius, minuteAngle);
    _drawSecondHand(canvas, center, radius, secondAngle);

    // --- Center dot ---
    _drawCenterDot(canvas, center);
  }

  void _drawGlowRing(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          gold.withOpacity(0.08),
          gold.withOpacity(0.02),
          Colors.transparent,
        ],
        stops: [0.85, 0.95, 1.1],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 20))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius + 20, paint);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    // Subtle outer ring
    final paint = Paint()
      ..color = gold.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, paint);

    // Inner ring
    final innerPaint = Paint()
      ..color = gold.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawCircle(center, radius * 0.92, innerPaint);
  }

  void _drawTickMarks(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * (pi / 180);
      final isMajor = i % 3 == 0;

      final outerX = center.dx + radius * 0.92 * cos(angle);
      final outerY = center.dy + radius * 0.92 * sin(angle);
      final innerX = center.dx + radius * (isMajor ? 0.80 : 0.85) * cos(angle);
      final innerY = center.dy + radius * (isMajor ? 0.80 : 0.85) * sin(angle);

      final paint = Paint()
        ..color = isMajor ? gold.withOpacity(0.7) : gold.withOpacity(0.3)
        ..strokeWidth = isMajor ? 2.0 : 1.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(outerX, outerY), Offset(innerX, innerY), paint);
    }
  }

  void _drawHourHand(Canvas canvas, Offset center, double radius, double angle) {
    final path = Path();
    final length = radius * 0.50;
    final baseWidth = 4.5;
    final tipWidth = 2.0;

    final tip = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );

    // Base points (perpendicular to hand direction)
    final perpAngle = angle + pi / 2;
    final baseBack = -radius * 0.12;

    final baseLeft = Offset(
      center.dx + baseBack * cos(angle) + baseWidth * cos(perpAngle),
      center.dy + baseBack * sin(angle) + baseWidth * sin(perpAngle),
    );
    final baseRight = Offset(
      center.dx + baseBack * cos(angle) - baseWidth * cos(perpAngle),
      center.dy + baseBack * sin(angle) - baseWidth * sin(perpAngle),
    );

    final tipLeft = Offset(
      tip.dx + tipWidth * cos(perpAngle),
      tip.dy + tipWidth * sin(perpAngle),
    );
    final tipRight = Offset(
      tip.dx - tipWidth * cos(perpAngle),
      tip.dy - tipWidth * sin(perpAngle),
    );

    path.moveTo(baseRight.dx, baseRight.dy);
    path.lineTo(tipRight.dx, tipRight.dy);
    path.lineTo(tipLeft.dx, tipLeft.dy);
    path.lineTo(baseLeft.dx, baseLeft.dy);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [goldBright, gold],
      ).createShader(Rect.fromCircle(center: center, radius: length))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Subtle shadow
    final shadowPath = Path()
      ..moveTo(baseRight.dx + 1, baseRight.dy + 1)
      ..lineTo(tipRight.dx + 1, tipRight.dy + 1)
      ..lineTo(tipLeft.dx + 1, tipLeft.dy + 1)
      ..lineTo(baseLeft.dx + 1, baseLeft.dy + 1)
      ..close();

    canvas.drawPath(shadowPath, Paint()..color = Colors.black.withOpacity(0.3));
  }

  void _drawMinuteHand(Canvas canvas, Offset center, double radius, double angle) {
    final path = Path();
    final length = radius * 0.72;
    final baseWidth = 3.0;
    final tipWidth = 1.5;

    final tip = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );

    final perpAngle = angle + pi / 2;
    final baseBack = -radius * 0.15;

    final baseLeft = Offset(
      center.dx + baseBack * cos(angle) + baseWidth * cos(perpAngle),
      center.dy + baseBack * sin(angle) + baseWidth * sin(perpAngle),
    );
    final baseRight = Offset(
      center.dx + baseBack * cos(angle) - baseWidth * cos(perpAngle),
      center.dy + baseBack * sin(angle) - baseWidth * sin(perpAngle),
    );

    final tipLeft = Offset(
      tip.dx + tipWidth * cos(perpAngle),
      tip.dy + tipWidth * sin(perpAngle),
    );
    final tipRight = Offset(
      tip.dx - tipWidth * cos(perpAngle),
      tip.dy - tipWidth * sin(perpAngle),
    );

    path.moveTo(baseRight.dx, baseRight.dy);
    path.lineTo(tipRight.dx, tipRight.dy);
    path.lineTo(tipLeft.dx, tipLeft.dy);
    path.lineTo(baseLeft.dx, baseLeft.dy);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [goldBright, goldDim],
      ).createShader(Rect.fromCircle(center: center, radius: length))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  void _drawSecondHand(Canvas canvas, Offset center, double radius, double angle) {
    final length = radius * 0.78;
    final backLength = radius * 0.18;

    final tip = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );
    final back = Offset(
      center.dx - backLength * cos(angle),
      center.dy - backLength * sin(angle),
    );

    // Main line
    final linePaint = Paint()
      ..color = secondHand
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(center, tip, linePaint);

    // Counterbalance
    final counterPaint = Paint()
      ..color = secondHand.withOpacity(0.5)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(center, back, counterPaint);

    // Tip dot
    final dotPaint = Paint()
      ..color = secondHand
      ..style = PaintingStyle.fill;

    canvas.drawCircle(tip, 2.5, dotPaint);
  }

  void _drawCenterDot(Canvas canvas, Offset center) {
    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          gold.withOpacity(0.6),
          gold.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 8))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 8, glowPaint);

    // Solid center
    final centerPaint = Paint()
      ..color = goldBright
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 3.5, centerPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx - 0.5, center.dy - 0.5), 1.5, highlightPaint);
  }

  double _hourAngle(DateTime now) {
    final hours = now.hour % 12;
    final minutes = now.minute / 60.0;
    return ((hours + minutes) * 30 - 90) * (pi / 180);
  }

  double _minuteAngle(DateTime now) {
    final minutes = now.minute;
    final seconds = now.second / 60.0;
    return ((minutes + seconds) * 6 - 90) * (pi / 180);
  }

  double _secondAngle(DateTime now) {
    final seconds = now.second;
    final millis = now.millisecond / 1000.0;
    return ((seconds + millis) * 6 - 90) * (pi / 180);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return dateTime != oldDelegate.dateTime;
  }
}
