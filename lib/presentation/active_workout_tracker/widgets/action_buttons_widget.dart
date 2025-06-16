import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onCompleteSet;
  final VoidCallback onSkipExercise;
  final VoidCallback onStartRestTimer;
  final bool isResting;
  final int currentSet;
  final int targetSets;

  const ActionButtonsWidget({
    super.key,
    required this.onCompleteSet,
    required this.onSkipExercise,
    required this.onStartRestTimer,
    required this.isResting,
    required this.currentSet,
    required this.targetSets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isResting ? null : onCompleteSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getSuccessColor(true),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme
                      .lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  elevation: 2,
                  shadowColor:
                      AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      currentSet == targetSets
                          ? 'Complete Exercise'
                          : 'Complete Set $currentSet',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Secondary Action Buttons
            Row(
              children: [
                // Skip Exercise Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: isResting ? null : onSkipExercise,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.getWarningColor(true),
                        side: BorderSide(
                          color: AppTheme.getWarningColor(true),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'skip_next',
                            color: AppTheme.getWarningColor(true),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Skip',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.getWarningColor(true),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Rest Timer Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextButton(
                      onPressed: isResting ? null : onStartRestTimer,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        backgroundColor: AppTheme
                            .lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'timer',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rest',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Helper Text
            Text(
              isResting
                  ? 'Rest in progress - buttons disabled'
                  : 'Long press exercise card for quick actions',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
