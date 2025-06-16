import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/muscle_group_chart_widget.dart';
import './widgets/strength_progression_chart_widget.dart';
import './widgets/workout_frequency_chart_widget.dart';

class ProgressAnalytics extends StatefulWidget {
  const ProgressAnalytics({super.key});

  @override
  State<ProgressAnalytics> createState() => _ProgressAnalyticsState();
}

class _ProgressAnalyticsState extends State<ProgressAnalytics>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDateRange = 'Month';
  bool _isLoading = false;
  int _currentChartIndex = 0;
  late PageController _chartPageController;

  // Mock data for analytics
  final List<Map<String, dynamic>> _metricCards = [
    {
      "title": "Total Workouts",
      "value": "47",
      "subtitle": "This month",
      "icon": "fitness_center",
      "color": Color(0xFF1B365D),
      "trend": "+12%",
      "isPositive": true,
    },
    {
      "title": "Calories Burned",
      "value": "12,450",
      "subtitle": "This month",
      "icon": "local_fire_department",
      "color": Color(0xFFFF6B35),
      "trend": "+8%",
      "isPositive": true,
    },
    {
      "title": "Personal Records",
      "value": "8",
      "subtitle": "New PRs",
      "icon": "emoji_events",
      "color": Color(0xFF2E7D32),
      "trend": "+3",
      "isPositive": true,
    },
    {
      "title": "Consistency Streak",
      "value": "14",
      "subtitle": "Days",
      "icon": "trending_up",
      "color": Color(0xFF4A90E2),
      "trend": "Active",
      "isPositive": true,
    },
  ];

  final List<Map<String, dynamic>> _workoutFrequencyData = [
    {"day": "Mon", "workouts": 3},
    {"day": "Tue", "workouts": 2},
    {"day": "Wed", "workouts": 4},
    {"day": "Thu", "workouts": 1},
    {"day": "Fri", "workouts": 3},
    {"day": "Sat", "workouts": 2},
    {"day": "Sun", "workouts": 1},
  ];

  final List<Map<String, dynamic>> _muscleGroupData = [
    {"name": "Chest", "percentage": 25.0, "color": Color(0xFF1B365D)},
    {"name": "Back", "percentage": 20.0, "color": Color(0xFF2E7D32)},
    {"name": "Legs", "percentage": 30.0, "color": Color(0xFFFF6B35)},
    {"name": "Arms", "percentage": 15.0, "color": Color(0xFF4A90E2)},
    {"name": "Core", "percentage": 10.0, "color": Color(0xFFF57C00)},
  ];

  final List<Map<String, dynamic>> _strengthProgressionData = [
    {"exercise": "Bench Press", "weight": 185, "maxWeight": 200},
    {"exercise": "Squat", "weight": 225, "maxWeight": 250},
    {"exercise": "Deadlift", "weight": 275, "maxWeight": 300},
    {"exercise": "Overhead Press", "weight": 135, "maxWeight": 150},
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      "title": "First Workout",
      "description": "Complete your first workout session",
      "icon": "play_arrow",
      "isUnlocked": true,
      "unlockedDate": "2024-01-15",
    },
    {
      "title": "Week Warrior",
      "description": "Complete 7 workouts in a week",
      "icon": "calendar_view_week",
      "isUnlocked": true,
      "unlockedDate": "2024-01-22",
    },
    {
      "title": "Consistency King",
      "description": "Maintain a 14-day workout streak",
      "icon": "trending_up",
      "isUnlocked": true,
      "unlockedDate": "2024-02-05",
    },
    {
      "title": "Strength Master",
      "description": "Achieve 10 personal records",
      "icon": "emoji_events",
      "isUnlocked": false,
      "unlockedDate": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _chartPageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chartPageController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _exportProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Progress report exported successfully!'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with date range selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress Analytics',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      GestureDetector(
                        onTap: _exportProgress,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.getAccentColor(isLight)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.getAccentColor(isLight),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DateRangeSelectorWidget(
                    selectedRange: _selectedDateRange,
                    onRangeChanged: (range) {
                      setState(() {
                        _selectedDateRange = range;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: Theme.of(context).cardColor,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      _navigateToScreen('/workout-dashboard');
                      break;
                    case 1:
                      _navigateToScreen('/workout-routines-library');
                      break;
                    case 2:
                      // Stay on current screen
                      break;
                  }
                },
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Routines'),
                  Tab(text: 'Progress'),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Metric Cards Section
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _metricCards.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final metric = _metricCards[index];
                            return MetricCardWidget(
                              title: metric["title"] as String,
                              value: metric["value"] as String,
                              subtitle: metric["subtitle"] as String,
                              iconName: metric["icon"] as String,
                              color: metric["color"] as Color,
                              trend: metric["trend"] as String,
                              isPositive: metric["isPositive"] as bool,
                              onLongPress: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Detailed breakdown for ${metric["title"]}'),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Charts Section
                      Text(
                        'Analytics Overview',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Chart Page View
                      SizedBox(
                        height: 300,
                        child: PageView(
                          controller: _chartPageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentChartIndex = index;
                            });
                          },
                          children: [
                            WorkoutFrequencyChartWidget(
                              data: _workoutFrequencyData,
                            ),
                            MuscleGroupChartWidget(
                              data: _muscleGroupData,
                            ),
                            StrengthProgressionChartWidget(
                              data: _strengthProgressionData,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Chart Page Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentChartIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentChartIndex == index
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Achievements Section
                      Text(
                        'Achievements',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _achievements.length,
                        itemBuilder: (context, index) {
                          final achievement = _achievements[index];
                          return AchievementBadgeWidget(
                            title: achievement["title"] as String,
                            description: achievement["description"] as String,
                            iconName: achievement["icon"] as String,
                            isUnlocked: achievement["isUnlocked"] as bool,
                            unlockedDate:
                                achievement["unlockedDate"] as String?,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Achievement: ${achievement["title"]}'),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
