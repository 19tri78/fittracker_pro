import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String) onSocialLogin;

  const SocialLoginWidget({
    super.key,
    required this.onSocialLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        Text(
          'Continue with',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Google Login
            _SocialLoginButton(
              onTap: () => onSocialLogin('Google'),
              iconName: 'g_translate', // Using closest available icon
              label: 'Google',
              backgroundColor: Colors.white,
              borderColor: AppTheme.lightTheme.colorScheme.outline,
              textColor: AppTheme.lightTheme.colorScheme.onSurface,
            ),

            // Apple Login
            _SocialLoginButton(
              onTap: () => onSocialLogin('Apple'),
              iconName:
                  'apple', // Using apple icon if available, otherwise phone_iphone
              label: 'Apple',
              backgroundColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.white,
            ),

            // Facebook Login
            _SocialLoginButton(
              onTap: () => onSocialLogin('Facebook'),
              iconName: 'facebook',
              label: 'Facebook',
              backgroundColor: const Color(0xFF1877F2),
              borderColor: const Color(0xFF1877F2),
              textColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconName;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _SocialLoginButton({
    required this.onTap,
    required this.iconName,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: textColor,
                  size: 5.w,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
