import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_workouts_widget.dart';
import './widgets/today_workout_card_widget.dart';

class WorkoutDashboard extends StatefulWidget {
  const WorkoutDashboard({super.key});

  @override
  State<WorkoutDashboard> createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRefreshing = false;

  // Mock data for dashboard
  final Map<String, dynamic> userData = {
    "name": "Alex Johnson",
    "currentDate": DateTime.now(),
  };

  final Map<String, dynamic> todayWorkout = {
    "id": 1,
    "name": "Upper Body Strength",
    "duration": "45 min",
    "exerciseCount": 8,
    "difficulty": "Intermediate",
    "image":
        "https://images.pexels.com/photos/416809/pexels-photo-416809.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "isCompleted": false,
  };

  final List<Map<String, dynamic>> quickStats = [
    {
      "title": "Workouts",
      "value": "12",
      "subtitle": "This Week",
      "icon": "fitness_center",
      "color": Color(0xFF2E7D32),
    },
    {
      "title": "Calories",
      "value": "2,450",
      "subtitle": "Burned",
      "icon": "local_fire_department",
      "color": Color(0xFFFF6B35),
    },
    {
      "title": "Time",
      "value": "8.5h",
      "subtitle": "Total",
      "icon": "schedule",
      "color": Color(0xFF1B365D),
    },
  ];

  final List<Map<String, dynamic>> recentWorkouts = [
    {
      "id": 1,
      "name": "Morning Cardio Blast",
      "date": "Today",
      "duration": "30 min",
      "calories": 285,
      "isCompleted": true,
      "completionRate": 100,
      "image":
          "https://images.pexels.com/photos/863988/pexels-photo-863988.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "exercises": ["Running", "Burpees", "Jump Rope"],
    },
    {
      "id": 2,
      "name": "Full Body HIIT",
      "date": "Yesterday",
      "duration": "40 min",
      "calories": 420,
      "isCompleted": true,
      "completionRate": 95,
      "image":
          "https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "exercises": ["Squats", "Push-ups", "Mountain Climbers"],
    },
    {
      "id": 3,
      "name": "Yoga Flow",
      "date": "2 days ago",
      "duration": "60 min",
      "calories": 180,
      "isCompleted": true,
      "completionRate": 100,
      "image":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "exercises": ["Sun Salutation", "Warrior Pose", "Tree Pose"],
    },
    {
      "id": 4,
      "name": "Strength Training",
      "date": "3 days ago",
      "duration": "50 min",
      "calories": 350,
      "isCompleted": false,
      "completionRate": 75,
      "image":
          "https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "exercises": ["Deadlifts", "Bench Press", "Squats"],
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/workout-routines-library');
        break;
      case 2:
        Navigator.pushNamed(context, '/progress-analytics');
        break;
      case 3:
        // Profile screen not implemented
        break;
    }
  }

  void _startWorkout() {
    Navigator.pushNamed(context, '/active-workout-tracker');
  }

  void _createNewWorkout() {
    Navigator.pushNamed(context, '/workout-routines-library');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Header
                    GreetingHeaderWidget(
                      userName: userData["name"] as String,
                      currentDate: userData["currentDate"] as DateTime,
                    ),

                    SizedBox(height: 2.h),

                    // Today's Workout Card
                    TodayWorkoutCardWidget(
                      workoutData: todayWorkout,
                      onStartWorkout: _startWorkout,
                    ),

                    SizedBox(height: 3.h),

                    // Quick Stats
                    QuickStatsWidget(
                      statsData: quickStats,
                    ),

                    SizedBox(height: 3.h),

                    // Recent Workouts Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Workouts',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/workout-routines-library');
                            },
                            child: Text(
                              'View All',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),
                  ],
                ),
              ),

              // Recent Workouts List
              RecentWorkoutsWidget(
                workoutsData: recentWorkouts,
                onWorkoutTap: (workout) {
                  Navigator.pushNamed(context, '/active-workout-tracker');
                },
              ),

              // Bottom padding for FAB
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _selectedIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'fitness_center',
              color: _selectedIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _selectedIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewWorkout,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
        elevation: 4.0,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'New Workout',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
