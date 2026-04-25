// lib/screens/widgets/last_workout_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_flow/models/workout.dart';
import 'package:intl/intl.dart';

import '../../services/workoutservice.dart';

class LastWorkoutCard extends StatefulWidget {
  const LastWorkoutCard({super.key});

  @override
  State<LastWorkoutCard> createState() => _LastWorkoutCardState();
}

class _LastWorkoutCardState extends State<LastWorkoutCard> {
  Workout? _lastWorkout;

  Future<void> _loadLastWorkout() async {
    final service = context.read<WorkoutService>();
    final workout = await service.getLastWorkout();
    if (mounted) {
      setState(() {
        _lastWorkout = workout;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload every time dependencies (like auth) change or screen is shown
    _loadLastWorkout();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastWorkout == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Workout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              const Text('No workouts yet'),
            ],
          ),
        ),
      );
    }

    final workout = _lastWorkout!;
    final exerciseNames = workout.exercises.map((e) => e.name).join(', ');
    final duration = '${workout.durationSeconds ~/ 60}m ${workout.durationSeconds % 60}s';
    final date = DateFormat('MMM d').format(workout.timestamp);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Workout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Text(exerciseNames),
            Text('Duration: $duration'),
            Text('Completed: $date'),
          ],
        ),
      ),
    );
  }
}