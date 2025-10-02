import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/alarm.dart';
import '../services/alarm_storage.dart';
import '../services/notification_service.dart';
import '../core/constants/app_constants.dart';

class AlarmController extends GetxController {
  final AlarmStorage _storage = AlarmStorage();
  final NotificationService _notificationService = NotificationService();

  // Observable list of alarms
  final RxList<Alarm> alarms = <Alarm>[].obs;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Error state
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  /// Initialize services and load alarms
  Future<void> _initializeServices() async {
    try {
      isLoading.value = true;
      await _notificationService.initialize();
      await _notificationService.requestPermissions();
      await loadAlarms();
    } catch (e) {
      errorMessage.value = 'Failed to initialize: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load all alarms from storage
  Future<void> loadAlarms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final loadedAlarms = await _storage.loadAlarms();
      alarms.value = loadedAlarms;
    } catch (e) {
      errorMessage.value = 'Failed to load alarms: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new alarm
  Future<bool> addAlarm(Alarm alarm) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _storage.addAlarm(alarm);
      
      if (alarm.isActive) {
        await _notificationService.scheduleAlarm(alarm);
      }
      
      await loadAlarms();
      _showSuccessSnackbar(AppStrings.alarmAdded);
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to add alarm: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing alarm
  Future<bool> updateAlarm(Alarm alarm) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _storage.updateAlarm(alarm);
      
      // Cancel existing notifications and reschedule if active
      await _notificationService.cancelAlarm(alarm);
      if (alarm.isActive) {
        await _notificationService.scheduleAlarm(alarm);
      }
      
      await loadAlarms();
      _showSuccessSnackbar(AppStrings.alarmUpdated);
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update alarm: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete an alarm
  Future<void> deleteAlarm(Alarm alarm) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _notificationService.cancelAlarm(alarm);
      await _storage.deleteAlarm(alarm.id);
      await loadAlarms();
      _showSuccessSnackbar(AppStrings.alarmDeleted);
    } catch (e) {
      errorMessage.value = 'Failed to delete alarm: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle alarm active state
  Future<void> toggleAlarm(Alarm alarm) async {
    try {
      final updatedAlarm = alarm.copyWith(isActive: !alarm.isActive);
      
      await _storage.updateAlarm(updatedAlarm);
      
      if (updatedAlarm.isActive) {
        await _notificationService.scheduleAlarm(updatedAlarm);
      } else {
        await _notificationService.cancelAlarm(updatedAlarm);
      }
      
      await loadAlarms();
    } catch (e) {
      errorMessage.value = 'Failed to toggle alarm: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
    }
  }

  /// Get alarm by ID
  Alarm? getAlarmById(String id) {
    try {
      return alarms.firstWhere((alarm) => alarm.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if there are any active alarms
  bool get hasActiveAlarms {
    return alarms.any((alarm) => alarm.isActive);
  }

  /// Get count of active alarms
  int get activeAlarmsCount {
    return alarms.where((alarm) => alarm.isActive).length;
  }

  /// Sort alarms by time
  void sortAlarmsByTime() {
    alarms.sort((a, b) {
      final aTime = a.hour * 60 + a.minute;
      final bTime = b.hour * 60 + b.minute;
      return aTime.compareTo(bTime);
    });
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.md,
      duration: const Duration(seconds: 2),
      animationDuration: AppDurations.medium,
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.md,
      duration: const Duration(seconds: 3),
      animationDuration: AppDurations.medium,
    );
  }

  /// Show info snackbar
  void showInfoSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.md,
      duration: const Duration(seconds: 2),
      animationDuration: AppDurations.medium,
    );
  }

  /// Clear all alarms
  Future<void> clearAllAlarms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _notificationService.cancelAllAlarms();
      await _storage.clearAllAlarms();
      await loadAlarms();
      _showSuccessSnackbar('All alarms cleared');
    } catch (e) {
      errorMessage.value = 'Failed to clear alarms: $e';
      _showErrorSnackbar(AppStrings.errorOccurred);
    } finally {
      isLoading.value = false;
    }
  }
}
