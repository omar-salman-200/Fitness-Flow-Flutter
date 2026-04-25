// lib/screens/breathing/breathing_exercise_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  String _instruction = 'Press Start';
  int _phase = -1; // -1 = idle, 0 = inhale, 1 = hold, 2 = exhale
  Timer? _holdTimer;
  Timer? _exhaleTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _sizeAnimation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _exhaleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _instruction = 'Breathe In';
      _phase = 0;
    });
    _controller.forward(from: 0).then((_) {
      // Inhale done → Hold
      setState(() {
        _instruction = 'Hold';
        _phase = 1;
      });
      _holdTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _instruction = 'Breathe Out';
            _phase = 2;
          });
          _controller.reverse().then((_) {
            if (mounted) {
              // Cycle ends → go back to start
              setState(() {
                _instruction = 'Press Start';
                _phase = -1;
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breathing Exercise')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (context, child) {
                return Container(
                  width: _sizeAnimation.value,
                  height: _sizeAnimation.value,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            if (_phase == -1)
              ElevatedButton(
                onPressed: _startBreathing,
                child: const Text('Start'),
              ),
            const SizedBox(height: 16),
            const Text(
              '4-4-4 Breathing Cycle',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}