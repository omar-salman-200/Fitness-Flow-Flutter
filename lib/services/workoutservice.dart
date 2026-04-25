// lib/services/workout_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flow/models/workout.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveWorkout(Workout workout) async {
    try {
      if (_auth.currentUser == null) {
        print("❌ No user logged in — cannot save workout");
        return;
      }

      final data = workout.toJson();
      print("💾 Saving workout  $data");

      await _firestore.collection('workouts').add(data);
      print("✅ Workout saved successfully!");

    } catch (e) {
      print("🔥 Error saving workout: $e");
      rethrow;
    }
  }

  Future<Workout?> getLastWorkout() async {
    final user = _auth.currentUser;
    if (user == null) {
      print("❌ No user logged in — cannot fetch workout");
      return null;
    }

    print("🔍 Fetching last workout for user ID: ${user.uid}");

    try {
      final snapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      print("📊 Firestore returned ${snapshot.docs.length} documents");

      if (snapshot.docs.isEmpty) {
        print("📭 No workouts found for this user");
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data();
      print("📄 Raw workout data  $data");

      final workout = Workout.fromJson(data);
      workout.id = doc.id; // Assign document ID
      return workout;

    } catch (e) {
      print("🔥 Error fetching last workout: $e");
      return null;
    }
  }
}