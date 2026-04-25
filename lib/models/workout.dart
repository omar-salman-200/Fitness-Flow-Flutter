import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  String? id;
  final String userId;
  final DateTime timestamp;
  final int durationSeconds;
  final List<Exercise> exercises;

  Workout({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.durationSeconds,
    required this.exercises,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'durationSeconds': durationSeconds,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  static Workout fromJson(Map<String, dynamic> json) {
    final exercises = (json['exercises'] as List?)
        ?.map((e) => Exercise.fromJson(e))
        .toList() ?? [];

    return Workout(
      id: json['id'],
      userId: json['userId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      durationSeconds: json['durationSeconds'],
      exercises: exercises,
    );
  }
}

// ✅ Only ONE Exercise class here
class Exercise {
  final String name;
  final int sets;
  final int reps;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
    };
  }

  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
    );
  }
}