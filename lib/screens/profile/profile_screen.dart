import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_flow/screens/providers/water_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _goalController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Load name from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final name = userDoc.data()?['name'] as String? ?? user.displayName ?? 'User';
      _nameController.text = name;
    }

    // Load water goal from WaterProvider (which syncs with Firestore)
    final waterProvider = context.read<WaterProvider>();
    _goalController.text = waterProvider.dailyGoal.toString();
  }

  Future<void> _saveName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'name': _nameController.text.trim()});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name updated!')));
  }

  Future<void> _changePassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      setState(() => _isLoading = true);
      await user.updatePassword(_passwordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated!')));
      _passwordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveWaterGoal() async {
    final goal = int.tryParse(_goalController.text);
    if (goal == null || goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid goal (e.g., 2000)')));
      return;
    }

    final waterProvider = context.read<WaterProvider>();
    waterProvider.setGoal(goal);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Water goal updated!')));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: Text('Not signed in'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                suffixIcon: Icon(Icons.edit, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveName,
              child: const Text('Save Name'),
            ),
            const SizedBox(height: 24),

            // Email (read-only)
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(
                labelText: 'Email',
                enabled: false,
              ),
            ),
            const SizedBox(height: 24),

            // Password
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Change Password'),
            ),
            const SizedBox(height: 24),

            // Water Goal
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Daily Water Goal (ml)',
                suffixText: 'ml',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveWaterGoal,
              child: const Text('Save Water Goal'),
            ),
            const SizedBox(height: 24),

            // Stats (simplified)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Stats', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    SizedBox(height: 8),
                    Text('• Total Workouts: 5'),
                    Text('• Water This Week: 12,500 ml'),
                    Text('• Breathing Sessions: 3'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}