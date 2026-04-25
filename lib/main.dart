import 'package:fitness_flow/screens/auth/forgot_password_screen.dart';
import 'package:fitness_flow/screens/auth/login_screen.dart';
import 'package:fitness_flow/screens/auth/signup_screen.dart';
import 'package:fitness_flow/screens/breathing/breathingExerciseScreen.dart';
import 'package:fitness_flow/screens/home/home_screen.dart';
import 'package:fitness_flow/screens/profile/profile_screen.dart';
import 'package:fitness_flow/screens/workout/add_workout_screen.dart';
import 'package:fitness_flow/services/workoutservice.dart';
import 'package:fitness_flow/services/auth_service.dart';
import 'package:fitness_flow/screens/providers/water_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flow/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
        ChangeNotifierProvider<WaterProvider>(create: (context) => WaterProvider()),
        Provider<WorkoutService>(create: (context) => WorkoutService()),
      ],
      child: MaterialApp(
        title: 'Fitness Flow',
        theme: ThemeData(
          useMaterial3: true,

          // ——— Color Scheme ———
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            primary: Colors.teal,
            secondary: Colors.tealAccent,
            background: const Color(0xFFF9F6F0),
            surface: Colors.white,
          ),

          // ——— Scaffold Background ———
          scaffoldBackgroundColor: const Color(0xFFF9F6F0),

          // ——— AppBar ———
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),

          // ——— Buttons ———
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // ——— Input Fields ———
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
          ),

          // ——— Cards ——— (FIXED: CardThemeData)
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (context) => const SignUpScreen());
            case '/home':
              return MaterialPageRoute(builder: (context) => const HomeScreen());
            case '/forgot_password':
              return MaterialPageRoute(builder: ( context) => const ForgotPasswordScreen());
            case '/add_workout':
              return MaterialPageRoute(builder: (context) => const AddWorkoutScreen());
            case '/breathing':
              return MaterialPageRoute(builder: (context) => const BreathingExerciseScreen());
            case '/profile':
              return MaterialPageRoute(builder: (context) => const ProfileScreen());
            default:
              return MaterialPageRoute(builder: (context) => const LoginScreen());
          }
        },
      ),
    );
  }
}