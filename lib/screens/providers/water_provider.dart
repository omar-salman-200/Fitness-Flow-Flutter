// lib/screens/providers/water_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _currentIntake = 0;
  int _dailyGoal = 2000;
  String? _documentId; // To update the same doc

  int get currentIntake => _currentIntake;
  int get dailyGoal => _dailyGoal;
  double get progress => _dailyGoal > 0 ? _currentIntake / _dailyGoal : 0;

  // Initialize from Firestore when user opens home screen
  Future<void> initialize() async {
    if (_auth.currentUser == null) return;

    final today = DateTime.now();
    final String dateKey = '${today.year}-${today.month}-${today.day}';

    final doc = await _firestore
        .collection('water_intakes')
        .doc(_auth.currentUser!.uid)
        .collection('daily')
        .doc(dateKey)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _currentIntake = data['amount'] ?? 0;
      _dailyGoal = data['goal'] ?? 2000;
      _documentId = doc.id;
    } else {
      _currentIntake = 0;
      _dailyGoal = 2000;
      _documentId = dateKey;
    }
    notifyListeners();
  }

  Future<void> add250ml() async {
    _currentIntake += 250;
    if (_currentIntake > _dailyGoal) _currentIntake = _dailyGoal;

    // Save to Firestore
    if (_auth.currentUser != null && _documentId != null) {
      await _firestore
          .collection('water_intakes')
          .doc(_auth.currentUser!.uid)
          .collection('daily')
          .doc(_documentId!)
          .set({
        'amount': _currentIntake,
        'goal': _dailyGoal,
        'date': DateTime.now(),
      });
    }

    notifyListeners();
  }

  Future<void> setGoal(int goal) async {
    _dailyGoal = goal;
    if (_auth.currentUser != null && _documentId != null) {
      await _firestore
          .collection('water_intakes')
          .doc(_auth.currentUser!.uid)
          .collection('daily')
          .doc(_documentId!)
          .update({'goal': goal});
    }
    notifyListeners();
  }
}