import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic> filters) onApplyFilters;

  const FilterModalWidget({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  final Map<String, dynamic> _filters = {
    'difficulty': <String>[],
    'duration': <String>[],
    'equipment': <String>[],
    'muscleGroups': <String>[],
    'workoutType': <String>[],
  };

  final Map<String, bool> _sectionExpanded = {
    'difficulty': true,
    'duration': false,
    'equipment': false,
    'muscleGroups': false,
    'workoutType': false,
  };

  final Map<String, List<String>> _filterOptions = {
    'difficulty': ['Beginner', 'Intermediate', 'Advanced'],
    'duration': ['0-20 min', '20-40 min', '40-60 min', '60+ min'],
    'equipment': [
      'None',
      'Dumbbells',
      'Barbell',
      'Resistance Bands',
      'Yoga Mat',
      'Kettlebell'
    ],
    'muscleGroups': [
      'Full Body',
      'Chest',
      'Back',
      'Arms',
      'Legs',
      'Glutes',
      'Core',
      'Cardio',
      'Flexibility'
    ],
    'workoutType': [
      'Strength',
      'HIIT',
      'Cardio',
      'Yoga',
      'Pilates',
      'Stretching'
    ],
  };

  final Map<String, String> _sectionTitles = {
    'difficulty': 'Difficulty Level',
    'duration': 'Duration',
    'equipment': 'Equipment Needed',
    'muscleGroups': 'Muscle Groups',
    'workoutType': 'Workout Type',
  };

  final Map<String, String> _sectionIcons = {
    'difficulty': 'trending_up',
    'duration': 'schedule',
    'equipment': 'fitness_center',
    'muscleGroups': 'accessibility',
    'workoutType': 'category',
  };

  void _toggleFilter(String category, String value) {
    setState(() {
      final List<String> currentFilters = _filters[category] as List<String>;
      if (currentFilters.contains(value)) {
        currentFilters.remove(value);
      } else {
        currentFilters.add(value);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters.forEach((key, value) {
        (value as List<String>).clear();
      });
    });
  }

  int get _totalActiveFilters {
    return _filters.values
        .map((filters) => (filters as List<String>).length)
        .fold(0, (sum, count) => sum + count);
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

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Filter Routines',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (_totalActiveFilters > 0)
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'Clear All ($_totalActiveFilters)',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
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
          ),

          // Filter sections
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              children: _filterOptions.keys.map((category) {
                return _buildFilterSection(category);
              }).toList(),
            ),
          ),

          // Apply button
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onApplyFilters(_filters),
                  child: Text(
                    _totalActiveFilters > 0
                        ? 'Apply Filters ($_totalActiveFilters)'
                        : 'Apply Filters',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String category) {
    final isExpanded = _sectionExpanded[category] ?? false;
    final activeFilters = (_filters[category] as List<String>).length;

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: _sectionIcons[category]!,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            title: Text(
              _sectionTitles[category]!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activeFilters > 0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activeFilters.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: isExpanded ? 'expand_less' : 'expand_more',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _sectionExpanded[category] = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
              child: Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: _filterOptions[category]!.map((option) {
                  final isSelected =
                      (_filters[category] as List<String>).contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) => _toggleFilter(category, option),
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
