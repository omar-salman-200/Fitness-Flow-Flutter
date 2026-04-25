import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_flow/models/workout.dart';
import '../../services/workoutservice.dart';
import 'package:fitness_flow/services/auth_service.dart';
import '../widgets/StopwatchWidget.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final List<Exercise> _exercises = [];
  final _exerciseNameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  int _workoutDuration = 0; // in seconds

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _addExercise() {
    if (_exerciseNameController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final exercise = Exercise(
      name: _exerciseNameController.text.trim(),
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
    );

    setState(() {
      _exercises.add(exercise);
      _exerciseNameController.clear();
      _setsController.clear();
      _repsController.clear();
    });
  }

  Future<void> _saveWorkout() async {
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise')),
      );
      return;
    }

    final user = context.read<AuthService>().currentUser;
    if (user == null) return;

    final workout = Workout(
      userId: user.uid,
      timestamp: DateTime.now(),
      durationSeconds: _workoutDuration,
      exercises: _exercises,
    );

    final service = context.read<WorkoutService>();
    await service.saveWorkout(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout saved!')),
    );
    Navigator.pop(context); // Go back to Home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Stopwatch
            StopwatchWidget(
              onTimeUpdate: (time) {
                _workoutDuration = time;
              },
            ),
            const SizedBox(height: 16),

            // Exercise Form
            TextField(
              controller: _exerciseNameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g., Push-ups',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _setsController,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      hintText: '3',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      hintText: '15',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addExercise,
              icon: const Icon(Icons.add),
              label: const Text('Add Exercise'),
            ),
            const SizedBox(height: 16),

            // Exercise List
            if (_exercises.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final ex = _exercises[index];
                    return ListTile(
                      title: Text(ex.name),
                      subtitle: Text('${ex.sets} sets × ${ex.reps} reps'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _exercises.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }
}