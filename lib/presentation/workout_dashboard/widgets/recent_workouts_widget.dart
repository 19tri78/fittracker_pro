import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentWorkoutsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> workoutsData;
  final Function(Map<String, dynamic>) onWorkoutTap;

  const RecentWorkoutsWidget({
    super.key,
    required this.workoutsData,
    required this.onWorkoutTap,
  });

  @override
  Widget build(BuildContext context) {
    if (workoutsData.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final workout = workoutsData[index];
          return _buildWorkoutCard(context, workout);
        },
        childCount: workoutsData.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'fitness_center',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 40,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Workouts Yet',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first workout to get started on your fitness journey!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to create workout
            },
            child: Text('Create Your First Workout'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, Map<String, dynamic> workout) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key(workout["id"].toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomIconWidget(
            iconName: 'delete',
            color: Colors.white,
            size: 24,
          ),
        ),
        child: GestureDetector(
          onTap: () => onWorkoutTap(workout),
          onLongPress: () => _showWorkoutOptions(context, workout),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Workout Image
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: workout["image"] as String? ?? "",
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Workout Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              workout["name"] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildCompletionBadge(workout),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        workout["date"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          _buildMetric(
                            icon: 'schedule',
                            value: workout["duration"] as String,
                          ),
                          SizedBox(width: 4.w),
                          _buildMetric(
                            icon: 'local_fire_department',
                            value: "${workout["calories"]} cal",
                          ),
                        ],
                      ),
                      if (workout["completionRate"] != null &&
                          workout["completionRate"] < 100) ...[
                        SizedBox(height: 1.h),
                        _buildProgressBar(workout["completionRate"] as int),
                      ],
                    ],
                  ),
                ),

                // Action Button
                GestureDetector(
                  onTap: () => _showWorkoutOptions(context, workout),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionBadge(Map<String, dynamic> workout) {
    final isCompleted = workout["isCompleted"] as bool? ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
            : AppTheme.getWarningColor(true).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isCompleted ? 'check_circle' : 'schedule',
            color: isCompleted
                ? AppTheme.getSuccessColor(true)
                : AppTheme.getWarningColor(true),
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            isCompleted ? 'Done' : 'Paused',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isCompleted
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.getWarningColor(true),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({required String icon, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int completionRate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$completionRate%',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: completionRate / 100,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.primary,
          ),
          minHeight: 4,
        ),
      ],
    );
  }

  void _showWorkoutOptions(BuildContext context, Map<String, dynamic> workout) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              workout["name"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildBottomSheetOption(
              context,
              icon: 'play_arrow',
              title: 'Start Again',
              onTap: () {
                Navigator.pop(context);
                // Start workout again
              },
            ),
            _buildBottomSheetOption(
              context,
              icon: 'visibility',
              title: 'View Details',
              onTap: () {
                Navigator.pop(context);
                // View workout details
              },
            ),
            _buildBottomSheetOption(
              context,
              icon: 'edit',
              title: 'Edit Workout',
              onTap: () {
                Navigator.pop(context);
                // Edit workout
              },
            ),
            _buildBottomSheetOption(
              context,
              icon: 'share',
              title: 'Share',
              onTap: () {
                Navigator.pop(context);
                // Share workout
              },
            ),
            _buildBottomSheetOption(
              context,
              icon: 'delete',
              title: 'Delete',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                // Delete workout
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
