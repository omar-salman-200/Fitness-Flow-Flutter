# Fitness Flow - Mobile Health Tracker

I built Fitness Flow to create a seamless, real-time experience for tracking physical and mental health. This project was my deep dive into cross-platform mobile development using Flutter and cloud-based data management with Firebase.

### The Logic Behind the App
The app isn't just a static logger; it’s built for real-time interaction. I used Firestore as the backbone to ensure that as soon as a user logs a workout or a breathing session, it's synced across all their devices instantly.

### Technical Highlights
* Firebase Integration: Implemented Firebase Authentication for user sign-in and Firestore for NoSQL data storage.
* Data Security: I wrote custom Firestore Security Rules to ensure users can only access their own data, preventing any cross-user data leaks.
* Activity Tracking: Specialized modules for tracking three distinct areas:
    * Workouts: Logging intensity and calories.
    * Hydration: Monitoring daily water intake goals.
    * Mindfulness: Timing breathing sessions to help with stress management.
* Asynchronous Flow: Used Dart's async/await patterns to ensure the UI stays smooth and responsive while communicating with the cloud.

### Project Structure
* lib: The core Flutter logic and UI widgets.
* android & ios: Platform-specific configurations for mobile deployment.
* firebase.json: Configuration for the Firebase backend and security rules.

### Setup & Installation
1. Install the Flutter SDK on your machine.
2. Clone this repo and run `flutter pub get` to install dependencies.
3. Add your own `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) from your Firebase Console.
4. Run `flutter run` on your emulator or physical device.