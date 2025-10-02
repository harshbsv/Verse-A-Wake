import 'package:flutter/material.dart';

/// App Colors - Sleek minimal dark theme
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE94560);
  static const Color primaryLight = Color(0xFFFF6B88);
  static const Color primaryDark = Color(0xFFB82E45);
  
  // Background Colors
  static const Color background = Color(0xFF0D0D0D);
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF242424);
  
  // Surface Colors
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF707070);
  static const Color textDisabled = Color(0xFF4A4A4A);
  
  // Accent Colors
  static const Color accent = Color(0xFF6C63FF);
  static const Color success = Color(0xFF00D9A5);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE94560);
  static const Color info = Color(0xFF2196F3);
  
  // Border & Divider
  static const Color border = Color(0xFF2A2A2A);
  static const Color divider = Color(0xFF1E1E1E);
  
  // Shadow
  static const Color shadow = Color(0x40000000);
}

/// App Text Styles
class AppTextStyles {
  // Display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  // Headline
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // Title
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
  );
  
  // Label
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );
}

/// App Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// App Border Radius
class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static const double full = 9999.0;
}

/// App Strings
class AppStrings {
  // App Info
  static const String appName = 'Verse-A-Wake';
  static const String appVersion = '1.0.0';
  
  // Home Screen
  static const String homeTitle = 'Verse-A-Wake';
  static const String noAlarmsTitle = 'No alarms set';
  static const String noAlarmsSubtitle = 'Tap + to add a new alarm';
  
  // Alarm Actions
  static const String addAlarm = 'Add Alarm';
  static const String editAlarm = 'Edit Alarm';
  static const String deleteAlarm = 'Delete Alarm';
  static const String deleteAlarmMessage = 'Are you sure you want to delete this alarm?';
  static const String saveAlarm = 'Save Alarm';
  static const String updateAlarm = 'Update Alarm';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  
  // Alarm Details
  static const String alarmLabel = 'Alarm Label';
  static const String alarmLabelHint = 'e.g., Wake up, Meeting, etc.';
  static const String repeat = 'Repeat';
  static const String once = 'Once';
  static const String everyDay = 'Every day';
  static const String tapToChangeTime = 'Tap to change time';
  
  // Days
  static const String sunday = 'Sun';
  static const String monday = 'Mon';
  static const String tuesday = 'Tue';
  static const String wednesday = 'Wed';
  static const String thursday = 'Thu';
  static const String friday = 'Fri';
  static const String saturday = 'Sat';
  
  // Notifications
  static const String alarmNotificationTitle = 'Alarm';
  static const String alarmNotificationBody = 'Time to wake up!';
  
  // Messages
  static const String alarmAdded = 'Alarm added successfully';
  static const String alarmUpdated = 'Alarm updated successfully';
  static const String alarmDeleted = 'Alarm deleted successfully';
  static const String errorOccurred = 'An error occurred';
  static const String permissionRequired = 'Notification permission required';
}

/// App Durations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

/// Storage Keys
class StorageKeys {
  static const String alarms = 'alarms';
}
