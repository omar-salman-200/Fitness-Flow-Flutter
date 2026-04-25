import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_flow/screens/providers/water_provider.dart';
import '../../services/auth_service.dart';
import '../widgets/WaterProgressWidget.dart';
import '../widgets/last_workout_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize water data from Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WaterProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Flow'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              final authService = context.read<AuthService>();
              await authService.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            WaterProgressWidget(),
            const SizedBox(height: 24),
            LastWorkoutCard(),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Wait until user comes back from Add Workout
                      await Navigator.pushNamed(context, '/add_workout');
                      // Force reload last workout
                      final lastWorkoutCard = context.findAncestorWidgetOfExactType<LastWorkoutCard>();
                      if (lastWorkoutCard != null) {
                        // We'll add a method to refresh
                      }
                    },
                    child: const Text('Add Workout'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/breathing');
                    },
                    child: const Text('Start Breathing'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          context.read<WaterProvider>().add250ml();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}