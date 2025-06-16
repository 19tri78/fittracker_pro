import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/workout_dashboard/workout_dashboard.dart';
import '../presentation/progress_analytics/progress_analytics.dart';
import '../presentation/active_workout_tracker/active_workout_tracker.dart';
import '../presentation/workout_routines_library/workout_routines_library.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String authenticationScreen = '/authentication-screen';
  static const String workoutDashboard = '/workout-dashboard';
  static const String activeWorkoutTracker = '/active-workout-tracker';
  static const String workoutRoutinesLibrary = '/workout-routines-library';
  static const String progressAnalytics = '/progress-analytics';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    authenticationScreen: (context) => const AuthenticationScreen(),
    workoutDashboard: (context) => const WorkoutDashboard(),
    activeWorkoutTracker: (context) => const ActiveWorkoutTracker(),
    workoutRoutinesLibrary: (context) => const WorkoutRoutinesLibrary(),
    progressAnalytics: (context) => const ProgressAnalytics(),
  };
}
