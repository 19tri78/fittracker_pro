import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoutineCardWidget extends StatelessWidget {
  final Map<String, dynamic> routine;
  final Function(String action, Map<String, dynamic> routine) onAction;

  const RoutineCardWidget({
    super.key,
    required this.routine,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('routine_${routine['id']}'),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right actions
          _showQuickActions(context, ['start', 'favorite', 'duplicate']);
        } else {
          // Swipe left actions
          if (routine['isCustom'] as bool) {
            onAction('delete', routine);
          } else if (routine['isFavorite'] as bool) {
            onAction('favorite', routine);
          }
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showQuickActions(context, ['start', 'favorite', 'duplicate']);
          return false;
        } else {
          if (routine['isCustom'] as bool) {
            return await _showDeleteConfirmation(context);
          } else {
            onAction('favorite', routine);
            return false;
          }
        }
      },
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Routine thumbnail
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: routine['thumbnail'] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                    // Overlay gradient
                    Container(
                      width: double.infinity,
                      height: 25.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: GestureDetector(
                        onTap: () => onAction('favorite', routine),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: (routine['isFavorite'] as bool)
                                ? 'favorite'
                                : 'favorite_border',
                            color: (routine['isFavorite'] as bool)
                                ? Colors.red
                                : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Difficulty badge
                    Positioned(
                      top: 2.h,
                      left: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                              routine['difficulty'] as String),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          routine['difficulty'] as String,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                    // Duration and equipment
                    Positioned(
                      bottom: 2.h,
                      left: 4.w,
                      right: 4.w,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  routine['duration'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'fitness_center',
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      routine['equipment'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Routine details
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and creator
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routine['name'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: (routine['creator'] as String) ==
                                              'You'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      routine['creator'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: (routine['creator']
                                                        as String) ==
                                                    'You'
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Rating
                        Column(
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  routine['rating'].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              '${routine['exercises']} exercises',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Description
                    Text(
                      routine['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => onAction('start', routine),
                            child: Text('Start Workout'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        OutlinedButton(
                          onPressed: () => onAction('details', routine),
                          child: Text('Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'play_arrow' : 'delete',
                color: Colors.white,
                size: 32,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft
                    ? 'Quick Actions'
                    : (routine['isCustom'] as bool)
                        ? 'Delete'
                        : 'Remove',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context, List<String> actions) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ...actions.map((action) => ListTile(
                  leading: CustomIconWidget(
                    iconName: _getActionIcon(action),
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                  title: Text(_getActionTitle(action)),
                  onTap: () {
                    Navigator.pop(context);
                    onAction(action, routine);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onAction('edit', routine);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                onAction('share', routine);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                onAction('details', routine);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
                onAction('schedule', routine);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Routine'),
            content: Text(
                'Are you sure you want to delete "${routine['name']}"? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _getActionIcon(String action) {
    switch (action) {
      case 'start':
        return 'play_arrow';
      case 'favorite':
        return (routine['isFavorite'] as bool) ? 'favorite' : 'favorite_border';
      case 'duplicate':
        return 'content_copy';
      default:
        return 'help';
    }
  }

  String _getActionTitle(String action) {
    switch (action) {
      case 'start':
        return 'Start Workout';
      case 'favorite':
        return (routine['isFavorite'] as bool)
            ? 'Remove from Favorites'
            : 'Add to Favorites';
      case 'duplicate':
        return 'Duplicate';
      default:
        return 'Unknown';
    }
  }
}
