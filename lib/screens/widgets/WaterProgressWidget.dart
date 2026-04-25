import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_flow/screens/providers/water_provider.dart'; // 🔗 Match your path

class WaterProgressWidget extends StatelessWidget {
  const WaterProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final waterProvider = context.watch<WaterProvider>();
    final progress = waterProvider.progress;
    final current = waterProvider.currentIntake;
    final goal = waterProvider.dailyGoal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Water Intake',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            // Linear progress bar (simple & effective)
            SizedBox(
              height: 20,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$current / $goal ml',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}