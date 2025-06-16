import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateRoutineWizardWidget extends StatefulWidget {
  final Function(Map<String, dynamic> routineData) onCreateRoutine;

  const CreateRoutineWizardWidget({
    super.key,
    required this.onCreateRoutine,
  });

  @override
  State<CreateRoutineWizardWidget> createState() =>
      _CreateRoutineWizardWidgetState();
}

class _CreateRoutineWizardWidgetState extends State<CreateRoutineWizardWidget> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form data
  String _selectedDifficulty = 'Beginner';
  String _selectedDuration = '30 min';
  final List<String> _selectedEquipment = [];
  final List<String> _selectedMuscleGroups = [];
  final List<Map<String, dynamic>> _selectedExercises = [];

  final List<String> _difficultyOptions = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];
  final List<String> _durationOptions = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
    '90 min'
  ];
  final List<String> _equipmentOptions = [
    'None',
    'Dumbbells',
    'Barbell',
    'Resistance Bands',
    'Yoga Mat',
    'Kettlebell',
    'Pull-up Bar',
    'Bench'
  ];
  final List<String> _muscleGroupOptions = [
    'Chest',
    'Back',
    'Arms',
    'Shoulders',
    'Legs',
    'Glutes',
    'Core',
    'Cardio',
    'Flexibility'
  ];

  // Mock exercises data
  final List<Map<String, dynamic>> _mockExercises = [
    {
      "id": 1,
      "name": "Push-ups",
      "category": "Chest",
      "equipment": "None",
      "difficulty": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=300&h=200",
    },
    {
      "id": 2,
      "name": "Squats",
      "category": "Legs",
      "equipment": "None",
      "difficulty": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1434608519344-49d77a699e1d?fm=jpg&q=60&w=300&h=200",
    },
    {
      "id": 3,
      "name": "Dumbbell Rows",
      "category": "Back",
      "equipment": "Dumbbells",
      "difficulty": "Intermediate",
      "image":
          "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?fm=jpg&q=60&w=300&h=200",
    },
    {
      "id": 4,
      "name": "Plank",
      "category": "Core",
      "equipment": "None",
      "difficulty": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=300&h=200",
    },
    {
      "id": 5,
      "name": "Deadlifts",
      "category": "Legs",
      "equipment": "Barbell",
      "difficulty": "Advanced",
      "image":
          "https://images.unsplash.com/photo-1434608519344-49d77a699e1d?fm=jpg&q=60&w=300&h=200",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _createRoutine() {
    final routineData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'difficulty': _selectedDifficulty,
      'duration': _selectedDuration,
      'equipment': _selectedEquipment,
      'muscleGroups': _selectedMuscleGroups,
      'exercises': _selectedExercises,
      'creator': 'You',
      'isCustom': true,
      'isFavorite': false,
    };

    widget.onCreateRoutine(routineData);
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty;
      case 1:
        return true; // Difficulty and duration always have defaults
      case 2:
        return _selectedMuscleGroups.isNotEmpty;
      case 3:
        return _selectedExercises.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with progress
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Create New Routine',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Progress indicator
                Row(
                  children: List.generate(_totalSteps, (index) {
                    final isActive = index <= _currentStep;
                    return Expanded(
                      child: Container(
                        height: 0.5.h,
                        margin: EdgeInsets.only(
                            right: index < _totalSteps - 1 ? 2.w : 0),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicInfoStep(),
                _buildPreferencesStep(),
                _buildTargetMusclesStep(),
                _buildExerciseSelectionStep(),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canProceed()
                          ? (_currentStep == _totalSteps - 1
                              ? _createRoutine
                              : _nextStep)
                          : null,
                      child: Text(
                        _currentStep == _totalSteps - 1
                            ? 'Create Routine'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Give your routine a name and description',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Routine Name',
              hintText: 'e.g., Morning Full Body Workout',
            ),
            onChanged: (value) => setState(() {}),
          ),
          SizedBox(height: 3.h),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Describe your workout routine...',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Preferences',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Set difficulty level, duration, and equipment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 4.h),

          // Difficulty selection
          Text(
            'Difficulty Level',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            children: _difficultyOptions.map((difficulty) {
              final isSelected = _selectedDifficulty == difficulty;
              return ChoiceChip(
                label: Text(difficulty),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  }
                },
              );
            }).toList(),
          ),

          SizedBox(height: 4.h),

          // Duration selection
          Text(
            'Expected Duration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            children: _durationOptions.map((duration) {
              final isSelected = _selectedDuration == duration;
              return ChoiceChip(
                label: Text(duration),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedDuration = duration;
                    });
                  }
                },
              );
            }).toList(),
          ),

          SizedBox(height: 4.h),

          // Equipment selection
          Text(
            'Equipment Needed',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _equipmentOptions.map((equipment) {
              final isSelected = _selectedEquipment.contains(equipment);
              return FilterChip(
                label: Text(equipment),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedEquipment.add(equipment);
                    } else {
                      _selectedEquipment.remove(equipment);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMusclesStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Muscle Groups',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select the muscle groups you want to target',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _muscleGroupOptions.map((muscleGroup) {
              final isSelected = _selectedMuscleGroups.contains(muscleGroup);
              return FilterChip(
                label: Text(muscleGroup),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedMuscleGroups.add(muscleGroup);
                    } else {
                      _selectedMuscleGroups.remove(muscleGroup);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSelectionStep() {
    final filteredExercises = _mockExercises.where((exercise) {
      if (_selectedEquipment.isEmpty) return true;
      return _selectedEquipment.contains(exercise['equipment']) ||
          exercise['equipment'] == 'None';
    }).toList();

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Exercises',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose exercises for your routine (${_selectedExercises.length} selected)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                final isSelected =
                    _selectedExercises.any((e) => e['id'] == exercise['id']);

                return Card(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: exercise['image'] as String,
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      exercise['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Text(
                      '${exercise['category']} • ${exercise['equipment']} • ${exercise['difficulty']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedExercises.add(exercise);
                          } else {
                            _selectedExercises
                                .removeWhere((e) => e['id'] == exercise['id']);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedExercises
                              .removeWhere((e) => e['id'] == exercise['id']);
                        } else {
                          _selectedExercises.add(exercise);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
