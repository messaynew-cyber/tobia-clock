import 'package:flutter/material.dart';
import '../widgets/clock_painter.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final newNow = DateTime.now();
    // Only repaint if second or sub-second changed
    if (newNow.second != _now.second ||
        newNow.millisecond != _now.millisecond) {
      setState(() {
        _now = newNow;
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final clockSize = size.width * 0.78;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.15),
            radius: 1.3,
            colors: [
              Color(0xFF1c1c28),
              Color(0xFF0a0a0f),
              Colors.black,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Analog Clock ---
              Center(
                child: CustomPaint(
                  size: Size(clockSize, clockSize),
                  painter: ClockPainter(dateTime: _now),
                ),
              ),
              const SizedBox(height: 36),
              // --- Digital Time ---
              Text(
                _formatTime(_now),
                style: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w200,
                  color: ClockPainter.gold,
                  letterSpacing: 5,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              // --- Seconds ---
              Text(
                _now.second.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: ClockPainter.gold.withOpacity(0.4),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 20),
              // --- Date ---
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ClockPainter.gold.withOpacity(0.15),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDate(_now),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: ClockPainter.gold.withOpacity(0.55),
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime now) {
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime now) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return '${days[now.weekday - 1]} · ${now.day} ${months[now.month - 1]} · ${now.year}';
  }
}
