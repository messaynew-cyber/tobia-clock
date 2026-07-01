import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter({required this.dateTime});

  static const Color gold = Color(0xFFE8D5B7);
  static const Color goldDim = Color(0xFFA09080);
  static const Color goldBright = Color(0xFFF5E6D3);
  static const Color secondHand = Color(0xFFD4A574);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 12;
    final now = dateTime;

    _drawGlowRing(canvas, c, r);
    _drawOuterRing(canvas, c, r);
    _drawTickMarks(canvas, c, r);

    final hourAngle = _hourAngle(now);
    final minuteAngle = _minuteAngle(now);
    final secondAngle = _secondAngle(now);

    _drawHourHand(canvas, c, r, hourAngle);
    _drawMinuteHand(canvas, c, r, minuteAngle);
    _drawSecondHand(canvas, c, r, secondAngle);
    _drawCenterDot(canvas, c);
  }

  void _drawGlowRing(Canvas canvas, Offset c, double r) {
    final rect = Rect.fromCircle(center: c, radius: r + 20);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          gold.withAlpha(20),
          gold.withAlpha(5),
          Colors.transparent,
        ],
        stops: const [0.85, 0.95, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(c, r + 20, paint);
  }

  void _drawOuterRing(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(
      c, r,
      Paint()
        ..color = gold.withAlpha(38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    canvas.drawCircle(
      c, r * 0.92,
      Paint()
        ..color = gold.withAlpha(20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  void _drawTickMarks(Canvas canvas, Offset c, double r) {
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * (pi / 180);
      final isMajor = i % 3 == 0;
      final outerX = c.dx + r * 0.92 * cos(angle);
      final outerY = c.dy + r * 0.92 * sin(angle);
      final innerMult = isMajor ? 0.80 : 0.85;
      final innerX = c.dx + r * innerMult * cos(angle);
      final innerY = c.dy + r * innerMult * sin(angle);

      canvas.drawLine(
        Offset(outerX, outerY),
        Offset(innerX, innerY),
        Paint()
          ..color = isMajor ? gold.withAlpha(179) : gold.withAlpha(77)
          ..strokeWidth = isMajor ? 2.0 : 1.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawHourHand(Canvas canvas, Offset c, double r, double angle) {
    final length = r * 0.50;
    final baseWidth = 4.5;
    final tipWidth = 2.0;
    final perpAngle = angle + pi / 2;
    final baseBack = -r * 0.12;

    final tip = Offset(c.dx + length * cos(angle), c.dy + length * sin(angle));
    final baseLeft = Offset(c.dx + baseBack * cos(angle) + baseWidth * cos(perpAngle),
        c.dy + baseBack * sin(angle) + baseWidth * sin(perpAngle));
    final baseRight = Offset(c.dx + baseBack * cos(angle) - baseWidth * cos(perpAngle),
        c.dy + baseBack * sin(angle) - baseWidth * sin(perpAngle));
    final tipLeft = Offset(tip.dx + tipWidth * cos(perpAngle), tip.dy + tipWidth * sin(perpAngle));
    final tipRight = Offset(tip.dx - tipWidth * cos(perpAngle), tip.dy - tipWidth * sin(perpAngle));

    final path = Path()
      ..moveTo(baseRight.dx, baseRight.dy)
      ..lineTo(tipRight.dx, tipRight.dy)
      ..lineTo(tipLeft.dx, tipLeft.dy)
      ..lineTo(baseLeft.dx, baseLeft.dy)
      ..close();

    final rect = Rect.fromCircle(center: c, radius: length);
    canvas.drawPath(path, Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [goldBright, gold],
      ).createShader(rect)
      ..style = PaintingStyle.fill);
  }

  void _drawMinuteHand(Canvas canvas, Offset c, double r, double angle) {
    final length = r * 0.72;
    final baseWidth = 3.0;
    final tipWidth = 1.5;
    final perpAngle = angle + pi / 2;
    final baseBack = -r * 0.15;

    final tip = Offset(c.dx + length * cos(angle), c.dy + length * sin(angle));
    final baseLeft = Offset(c.dx + baseBack * cos(angle) + baseWidth * cos(perpAngle),
        c.dy + baseBack * sin(angle) + baseWidth * sin(perpAngle));
    final baseRight = Offset(c.dx + baseBack * cos(angle) - baseWidth * cos(perpAngle),
        c.dy + baseBack * sin(angle) - baseWidth * sin(perpAngle));
    final tipLeft = Offset(tip.dx + tipWidth * cos(perpAngle), tip.dy + tipWidth * sin(perpAngle));
    final tipRight = Offset(tip.dx - tipWidth * cos(perpAngle), tip.dy - tipWidth * sin(perpAngle));

    final path = Path()
      ..moveTo(baseRight.dx, baseRight.dy)
      ..lineTo(tipRight.dx, tipRight.dy)
      ..lineTo(tipLeft.dx, tipLeft.dy)
      ..lineTo(baseLeft.dx, baseLeft.dy)
      ..close();

    final rect = Rect.fromCircle(center: c, radius: length);
    canvas.drawPath(path, Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [goldBright, goldDim],
      ).createShader(rect)
      ..style = PaintingStyle.fill);
  }

  void _drawSecondHand(Canvas canvas, Offset c, double r, double angle) {
    final length = r * 0.78;
    final backLength = r * 0.18;
    final tip = Offset(c.dx + length * cos(angle), c.dy + length * sin(angle));
    final back = Offset(c.dx - backLength * cos(angle), c.dy - backLength * sin(angle));

    canvas.drawLine(c, tip, Paint()
      ..color = secondHand
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);

    canvas.drawLine(c, back, Paint()
      ..color = secondHand.withAlpha(128)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);

    canvas.drawCircle(tip, 2.5, Paint()
      ..color = secondHand
      ..style = PaintingStyle.fill);
  }

  void _drawCenterDot(Canvas canvas, Offset c) {
    final glowRect = Rect.fromCircle(center: c, radius: 8);
    canvas.drawCircle(c, 8, Paint()
      ..shader = RadialGradient(
        colors: [gold.withAlpha(153), gold.withAlpha(26), Colors.transparent],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(glowRect)
      ..style = PaintingStyle.fill);

    canvas.drawCircle(c, 3.5, Paint()
      ..color = goldBright
      ..style = PaintingStyle.fill);

    canvas.drawCircle(Offset(c.dx - 0.5, c.dy - 0.5), 1.5, Paint()
      ..color = Colors.white.withAlpha(102)
      ..style = PaintingStyle.fill);
  }

  double _hourAngle(DateTime now) {
    final h = now.hour % 12 + now.minute / 60.0;
    return (h * 30 - 90) * (pi / 180);
  }

  double _minuteAngle(DateTime now) {
    final m = now.minute + now.second / 60.0;
    return (m * 6 - 90) * (pi / 180);
  }

  double _secondAngle(DateTime now) {
    final s = now.second + now.millisecond / 1000.0;
    return (s * 6 - 90) * (pi / 180);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return dateTime != oldDelegate.dateTime;
  }
}
