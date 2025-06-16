import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/exercise_card_widget.dart';
import './widgets/exit_confirmation_dialog_widget.dart';
import './widgets/quick_actions_bottom_sheet_widget.dart';
import './widgets/rest_timer_bottom_sheet_widget.dart';
import './widgets/workout_progress_header_widget.dart';

class ActiveWorkoutTracker extends StatefulWidget {
  const ActiveWorkoutTracker({super.key});

  @override
  State<ActiveWorkoutTracker> createState() => _ActiveWorkoutTrackerState();
}

class _ActiveWorkoutTrackerState extends State<ActiveWorkoutTracker>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late AnimationController _restTimerController;

  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _completedReps = 0;
  bool _isResting = false;
  int _restTimeRemaining = 0;
  final DateTime _workoutStartTime = DateTime.now();
  Duration _workoutDuration = Duration.zero;
  late Timer _workoutTimer;
  Timer? _restTimer;

  // Mock workout data
  final List<Map<String, dynamic>> _workoutExercises = [
    {
      "id": 1,
      "name": "Push-ups",
      "description":
          "Classic bodyweight exercise targeting chest, shoulders, and triceps",
      "imageUrl":
          "https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg?auto=compress&cs=tinysrgb&w=800",
      "targetSets": 3,
      "targetReps": 15,
      "restTime": 60,
      "difficulty": "Beginner",
      "muscleGroups": ["Chest", "Shoulders", "Triceps"],
      "instructions": [
        "Start in plank position with hands shoulder-width apart",
        "Lower your body until chest nearly touches the floor",
        "Push back up to starting position",
        "Keep your core engaged throughout the movement"
      ],
      "tips": [
        "Keep your body in a straight line",
        "Don't let your hips sag or pike up",
        "Control the movement - don't rush"
      ]
    },
    {
      "id": 2,
      "name": "Squats",
      "description":
          "Fundamental lower body exercise for building leg and glute strength",
      "imageUrl":
          "https://images.pexels.com/photos/703012/pexels-photo-703012.jpeg?auto=compress&cs=tinysrgb&w=800",
      "targetSets": 3,
      "targetReps": 20,
      "restTime": 90,
      "difficulty": "Beginner",
      "muscleGroups": ["Quadriceps", "Glutes", "Hamstrings"],
      "instructions": [
        "Stand with feet shoulder-width apart",
        "Lower your body by bending knees and hips",
        "Go down until thighs are parallel to floor",
        "Push through heels to return to start"
      ],
      "tips": [
        "Keep your chest up and core tight",
        "Don't let knees cave inward",
        "Weight should be on your heels"
      ]
    },
    {
      "id": 3,
      "name": "Plank",
      "description":
          "Isometric core exercise for building stability and endurance",
      "imageUrl":
          "https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&w=800",
      "targetSets": 3,
      "targetReps": 45,
      "restTime": 60,
      "difficulty": "Intermediate",
      "muscleGroups": ["Core", "Shoulders", "Back"],
      "instructions": [
        "Start in push-up position on forearms",
        "Keep body in straight line from head to heels",
        "Hold position for specified time",
        "Breathe normally throughout hold"
      ],
      "tips": [
        "Don't let hips sag or pike up",
        "Keep shoulders directly over elbows",
        "Engage your core muscles"
      ]
    },
    {
      "id": 4,
      "name": "Lunges",
      "description":
          "Unilateral leg exercise for balance, strength, and coordination",
      "imageUrl":
          "https://images.pexels.com/photos/4162449/pexels-photo-4162449.jpeg?auto=compress&cs=tinysrgb&w=800",
      "targetSets": 3,
      "targetReps": 12,
      "restTime": 75,
      "difficulty": "Intermediate",
      "muscleGroups": ["Quadriceps", "Glutes", "Hamstrings", "Calves"],
      "instructions": [
        "Step forward with one leg",
        "Lower hips until both knees are at 90 degrees",
        "Push back to starting position",
        "Alternate legs or complete all reps on one side"
      ],
      "tips": [
        "Keep front knee over ankle",
        "Don't let back knee touch ground",
        "Maintain upright torso"
      ]
    },
    {
      "id": 5,
      "name": "Mountain Climbers",
      "description":
          "Dynamic cardio exercise combining core strength with cardiovascular training",
      "imageUrl":
          "https://images.pexels.com/photos/4162438/pexels-photo-4162438.jpeg?auto=compress&cs=tinysrgb&w=800",
      "targetSets": 3,
      "targetReps": 30,
      "restTime": 60,
      "difficulty": "Advanced",
      "muscleGroups": ["Core", "Shoulders", "Legs", "Cardio"],
      "instructions": [
        "Start in plank position",
        "Bring one knee toward chest",
        "Quickly switch legs in running motion",
        "Maintain plank position throughout"
      ],
      "tips": [
        "Keep hips level - don't bounce",
        "Land softly on balls of feet",
        "Maintain steady breathing rhythm"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startWorkoutTimer();
    _preventScreenLock();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _restTimerController = AnimationController(
      duration: Duration(seconds: _getCurrentExercise()["restTime"] as int),
      vsync: this,
    );
  }

  void _startWorkoutTimer() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _workoutDuration = DateTime.now().difference(_workoutStartTime);
        });
      }
    });
  }

  void _preventScreenLock() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Map<String, dynamic> _getCurrentExercise() {
    return _workoutExercises[_currentExerciseIndex];
  }

  double _getWorkoutProgress() {
    int totalExercises = _workoutExercises.length;
    int totalSets = _workoutExercises.fold(
        0, (sum, exercise) => sum + (exercise["targetSets"] as int));
    int completedSets = 0;

    for (int i = 0; i < _currentExerciseIndex; i++) {
      completedSets += _workoutExercises[i]["targetSets"] as int;
    }
    completedSets += _currentSet - 1;

    return completedSets / totalSets;
  }

  void _completeSet() {
    HapticFeedback.mediumImpact();

    final currentExercise = _getCurrentExercise();
    final targetSets = currentExercise["targetSets"] as int;

    if (_currentSet < targetSets) {
      setState(() {
        _currentSet++;
        _completedReps = 0;
      });
      _startRestTimer();
    } else {
      _nextExercise();
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _workoutExercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
        _completedReps = 0;
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeWorkout();
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _currentSet = 1;
        _completedReps = 0;
      });

      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipExercise() {
    HapticFeedback.lightImpact();
    _nextExercise();
  }

  void _startRestTimer() {
    final restTime = _getCurrentExercise()["restTime"] as int;
    setState(() {
      _isResting = true;
      _restTimeRemaining = restTime;
    });

    _restTimerController.duration = Duration(seconds: restTime);
    _restTimerController.forward(from: 0);

    _showRestTimerBottomSheet();

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restTimeRemaining > 0) {
        setState(() {
          _restTimeRemaining--;
        });
      } else {
        _endRestTimer();
      }
    });
  }

  void _endRestTimer() {
    _restTimer?.cancel();
    _restTimerController.reset();
    setState(() {
      _isResting = false;
      _restTimeRemaining = 0;
    });
    Navigator.of(context).pop(); // Close rest timer bottom sheet
    HapticFeedback.mediumImpact();
  }

  void _skipRest() {
    _endRestTimer();
  }

  void _completeWorkout() {
    HapticFeedback.heavyImpact();
    Navigator.of(context).pushReplacementNamed('/workout-dashboard');
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => ExitConfirmationDialogWidget(
        onConfirmExit: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        onContinueWorkout: () {
          Navigator.of(context).pop();
        },
        workoutDuration: _workoutDuration,
        completedExercises: _currentExerciseIndex,
        totalExercises: _workoutExercises.length,
      ),
    );
  }

  void _showRestTimerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RestTimerBottomSheetWidget(
        restTimeRemaining: _restTimeRemaining,
        totalRestTime: _getCurrentExercise()["restTime"] as int,
        nextExercise: _currentExerciseIndex < _workoutExercises.length - 1
            ? _workoutExercises[_currentExerciseIndex + 1]
            : null,
        onSkipRest: _skipRest,
        animationController: _restTimerController,
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsBottomSheetWidget(
        exercise: _getCurrentExercise(),
        onViewFormTips: () {
          Navigator.of(context).pop();
          // Show form tips dialog
        },
        onSubstituteExercise: () {
          Navigator.of(context).pop();
          // Show exercise substitution options
        },
        onAddNotes: () {
          Navigator.of(context).pop();
          // Show notes input dialog
        },
      ),
    );
  }

  @override
  void dispose() {
    _workoutTimer.cancel();
    _restTimer?.cancel();
    _pageController.dispose();
    _progressAnimationController.dispose();
    _restTimerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Workout Progress Header
            WorkoutProgressHeaderWidget(
              progress: _getWorkoutProgress(),
              workoutDuration: _workoutDuration,
              currentExercise: _currentExerciseIndex + 1,
              totalExercises: _workoutExercises.length,
              onExit: _showExitConfirmation,
            ),

            // Main Exercise Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentExerciseIndex = index;
                    _currentSet = 1;
                    _completedReps = 0;
                  });
                },
                itemCount: _workoutExercises.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: _showQuickActions,
                    child: ExerciseCardWidget(
                      exercise: _workoutExercises[index],
                      currentSet: _currentSet,
                      completedReps: _completedReps,
                      isActive: index == _currentExerciseIndex,
                      onSwipeLeft: _nextExercise,
                      onSwipeRight: _previousExercise,
                    ),
                  );
                },
              ),
            ),

            // Action Buttons
            ActionButtonsWidget(
              onCompleteSet: _completeSet,
              onSkipExercise: _skipExercise,
              onStartRestTimer: _startRestTimer,
              isResting: _isResting,
              currentSet: _currentSet,
              targetSets: _getCurrentExercise()["targetSets"] as int,
            ),
          ],
        ),
      ),
    );
  }
}
