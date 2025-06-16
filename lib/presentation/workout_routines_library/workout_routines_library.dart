import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/create_routine_wizard_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/routine_card_widget.dart';

class WorkoutRoutinesLibrary extends StatefulWidget {
  const WorkoutRoutinesLibrary({super.key});

  @override
  State<WorkoutRoutinesLibrary> createState() => _WorkoutRoutinesLibraryState();
}

class _WorkoutRoutinesLibraryState extends State<WorkoutRoutinesLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedSection = 'My Routines';
  bool _isLoading = false;
  String _searchQuery = '';

  // Mock data for workout routines
  final List<Map<String, dynamic>> _mockRoutines = [
    {
      "id": 1,
      "name": "Full Body Strength",
      "creator": "FitTracker Pro",
      "difficulty": "Intermediate",
      "duration": "45 min",
      "equipment": "Dumbbells, Barbell",
      "rating": 4.8,
      "thumbnail":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=400&h=300",
      "muscleGroups": ["Full Body"],
      "workoutType": "Strength",
      "isFavorite": true,
      "isCustom": false,
      "exercises": 8,
      "description":
          "Complete full-body strength training routine targeting all major muscle groups."
    },
    {
      "id": 2,
      "name": "HIIT Cardio Blast",
      "creator": "CardioMaster",
      "difficulty": "Advanced",
      "duration": "30 min",
      "equipment": "None",
      "rating": 4.6,
      "thumbnail":
          "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?fm=jpg&q=60&w=400&h=300",
      "muscleGroups": ["Cardio"],
      "workoutType": "HIIT",
      "isFavorite": false,
      "isCustom": false,
      "exercises": 12,
      "description":
          "High-intensity interval training for maximum calorie burn and cardiovascular fitness."
    },
    {
      "id": 3,
      "name": "Upper Body Power",
      "creator": "You",
      "difficulty": "Intermediate",
      "duration": "40 min",
      "equipment": "Dumbbells",
      "rating": 4.9,
      "thumbnail":
          "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?fm=jpg&q=60&w=400&h=300",
      "muscleGroups": ["Chest", "Back", "Arms"],
      "workoutType": "Strength",
      "isFavorite": true,
      "isCustom": true,
      "exercises": 10,
      "description":
          "Custom upper body routine focusing on building strength and muscle definition."
    },
    {
      "id": 4,
      "name": "Yoga Flow Morning",
      "creator": "ZenFitness",
      "difficulty": "Beginner",
      "duration": "25 min",
      "equipment": "Yoga Mat",
      "rating": 4.7,
      "thumbnail":
          "https://images.unsplash.com/photo-1506629905607-d405b7a30db9?fm=jpg&q=60&w=400&h=300",
      "muscleGroups": ["Flexibility"],
      "workoutType": "Yoga",
      "isFavorite": false,
      "isCustom": false,
      "exercises": 15,
      "description":
          "Gentle morning yoga flow to energize your body and mind for the day ahead."
    },
    {
      "id": 5,
      "name": "Leg Day Destroyer",
      "creator": "LegendaryLifts",
      "difficulty": "Advanced",
      "duration": "50 min",
      "equipment": "Barbell, Squat Rack",
      "rating": 4.5,
      "thumbnail":
          "https://images.unsplash.com/photo-1434608519344-49d77a699e1d?fm=jpg&q=60&w=400&h=300",
      "muscleGroups": ["Legs", "Glutes"],
      "workoutType": "Strength",
      "isFavorite": true,
      "isCustom": false,
      "exercises": 7,
      "description":
          "Intense leg workout designed to build serious lower body strength and mass."
    },
    {
      "id": 6,
      "name": "Core Crusher",
      "creator": "AbsExpert",
      "difficulty": "Intermediate",
      "duration": "20 min",
      "equipment": "None",
      "rating": 4.4,
      "thumbnail":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=400&h=300",
      "muscleGroups": ["Core"],
      "workoutType": "Strength",
      "isFavorite": false,
      "isCustom": false,
      "exercises": 9,
      "description":
          "Targeted core workout to build a strong and stable midsection."
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRoutines {
    List<Map<String, dynamic>> filtered = _mockRoutines;

    // Filter by section
    if (_selectedSection == 'My Routines') {
      filtered = filtered
          .where((routine) =>
              (routine['isCustom'] as bool) ||
              (routine['creator'] as String) == 'You')
          .toList();
    } else if (_selectedSection == 'Favorites') {
      filtered =
          filtered.where((routine) => routine['isFavorite'] as bool).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((routine) {
        final name = (routine['name'] as String).toLowerCase();
        final creator = (routine['creator'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || creator.contains(query);
      }).toList();
    }

    return filtered;
  }

  void _onSectionChanged(String section) {
    setState(() {
      _selectedSection = section;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        onApplyFilters: (filters) {
          // Handle filter application
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCreateRoutineWizard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRoutineWizardWidget(
        onCreateRoutine: (routineData) {
          // Handle routine creation
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onRoutineAction(String action, Map<String, dynamic> routine) {
    switch (action) {
      case 'start':
        Navigator.pushNamed(context, '/active-workout-tracker');
        break;
      case 'favorite':
        setState(() {
          routine['isFavorite'] = !(routine['isFavorite'] as bool);
        });
        break;
      case 'duplicate':
        // Handle duplicate
        break;
      case 'delete':
        if (routine['isCustom'] as bool) {
          setState(() {
            _mockRoutines.removeWhere((r) => r['id'] == routine['id']);
          });
        }
        break;
      case 'edit':
        // Handle edit
        break;
      case 'share':
        // Handle share
        break;
      case 'details':
        // Handle view details
        break;
      case 'schedule':
        // Handle schedule
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filter
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // App bar
                  Row(
                    children: [
                      Text(
                        'Workout Routines',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/workout-dashboard'),
                        icon: CustomIconWidget(
                          iconName: 'home',
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search routines...',
                            prefixIcon: CustomIconWidget(
                              iconName: 'search',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                    icon: CustomIconWidget(
                                      iconName: 'clear',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 20,
                                    ),
                                  )
                                : null,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      IconButton(
                        onPressed: _showFilterModal,
                        icon: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'tune',
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Segmented control
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children:
                    ['My Routines', 'Favorites', 'Discover'].map((section) {
                  final isSelected = _selectedSection == section;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onSectionChanged(section),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          section,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Content
            Expanded(
              child: _filteredRoutines.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: _filteredRoutines.length,
                        itemBuilder: (context, index) {
                          final routine = _filteredRoutines[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: RoutineCardWidget(
                              routine: routine,
                              onAction: _onRoutineAction,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateRoutineWizard,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Create Routine',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'fitness_center',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              _selectedSection == 'My Routines'
                  ? 'No Custom Routines Yet'
                  : _selectedSection == 'Favorites'
                      ? 'No Favorite Routines'
                      : 'No Routines Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _selectedSection == 'My Routines'
                  ? 'Create your first custom workout routine to get started'
                  : _selectedSection == 'Favorites'
                      ? 'Mark routines as favorites to see them here'
                      : 'Try adjusting your search or browse popular routines',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: _selectedSection == 'Discover'
                  ? () => _onSectionChanged('Discover')
                  : _showCreateRoutineWizard,
              child: Text(
                _selectedSection == 'Discover'
                    ? 'Browse Popular Routines'
                    : 'Create New Routine',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
