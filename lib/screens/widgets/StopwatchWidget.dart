import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  final ValueChanged<int> onTimeUpdate; // Callback when time changes

  const StopwatchWidget({super.key, required this.onTimeUpdate});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  int _elapsedTime = 0; // in seconds

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  void _start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed.inSeconds;
        });
        widget.onTimeUpdate(_elapsedTime);
      });
    }
  }

  void _pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer.cancel();
    }
  }

  void _reset() {
    _stopwatch.reset();
    _timer.cancel();
    setState(() {
      _elapsedTime = 0;
    });
    widget.onTimeUpdate(0);
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else {
      return '${minutes}m ${secs}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Workout Timer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTime(_elapsedTime),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.small(
                  backgroundColor: Colors.teal,
                  onPressed: _start,
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
                FloatingActionButton.small(
                  backgroundColor: Colors.grey,
                  onPressed: _pause,
                  child: const Icon(Icons.pause, color: Colors.white),
                ),
                FloatingActionButton.small(
                  backgroundColor: Colors.red,
                  onPressed: _reset,
                  child: const Icon(Icons.stop, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}