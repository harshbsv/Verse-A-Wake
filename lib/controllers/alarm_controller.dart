import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/alarm.dart';
import '../services/alarm_storage.dart';
import '../services/notification_service.dart';
import '../core/constants/app_constants.dart';

class AlarmController extends GetxController {
  final AlarmStorage _storage = AlarmStorage();
  final NotificationService _notificationService = NotificationService();

  final RxList<Alarm> alarms = <Alarm>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    isLoading.value = true;
    try {
      await _notificationService.initialize();
      await loadAlarms();
    } catch (e, s) {
      print('Initialization failed: $e\n$s');
      errorMessage.value = 'Failed to initialize services.';
      _showErrorSnackbar('Initialization failed.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAlarms() async {
    try {
      final loadedAlarms = await _storage.loadAlarms();

      alarms.assignAll(loadedAlarms);
      sortAlarmsByTime();
    } catch (e, s) {
      print('Failed to load alarms: $e\n$s');
      errorMessage.value = 'Could not load alarms from storage.';
    }
  }

  Future<bool> addAlarm(Alarm alarm) async {
    isLoading.value = true;
    try {
      alarms.add(alarm);
      sortAlarmsByTime();

      await _storage.saveAlarms(alarms.toList());

      if (alarm.isActive) {
        await _notificationService.scheduleAlarm(alarm);
      }

      return true;
    } catch (e, s) {
      print('Failed to add alarm: $e\n$s');

      alarms.removeWhere((a) => a.id == alarm.id);
      errorMessage.value = 'Failed to save alarm.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateAlarm(Alarm alarm) async {
    isLoading.value = true;
    try {
      final index = alarms.indexWhere((a) => a.id == alarm.id);
      if (index != -1) {
        alarms[index] = alarm;
        sortAlarmsByTime();

        await _storage.saveAlarms(alarms.toList());

        await _notificationService.cancelAlarm(alarm);
        if (alarm.isActive) {
          await _notificationService.scheduleAlarm(alarm);
        }
        return true;
      }
      return false;
    } catch (e, s) {
      print('Failed to update alarm: $e\n$s');
      errorMessage.value = 'Failed to update alarm.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAlarm(Alarm alarm) async {
    isLoading.value = true;
    try {
      alarms.removeWhere((a) => a.id == alarm.id);

      await _storage.saveAlarms(alarms.toList());

      await _notificationService.cancelAlarm(alarm);

      _showSuccessSnackbar(AppStrings.alarmDeleted);
    } catch (e, s) {
      print('Failed to delete alarm: $e\n$s');

      alarms.add(alarm);
      sortAlarmsByTime();
      _showErrorSnackbar(AppStrings.errorOccurred);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearAllAlarms() async {
    isLoading.value = true;
    try {
      alarms.clear();

      await _storage.saveAlarms([]);

      await _notificationService.cancelAllAlarms();

      _showSuccessSnackbar('All alarms cleared');
    } catch (e, s) {
      print('Failed to clear alarms: $e\n$s');

      await loadAlarms();
      _showErrorSnackbar(AppStrings.errorOccurred);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAlarm(Alarm alarm) async {
    final index = alarms.indexWhere((a) => a.id == alarm.id);
    if (index == -1) return;

    final originalAlarm = alarms[index];
    final updatedAlarm = originalAlarm.copyWith(
      isActive: !originalAlarm.isActive,
    );

    alarms[index] = updatedAlarm;

    try {
      await _storage.saveAlarms(alarms.toList());

      if (updatedAlarm.isActive) {
        await _notificationService.scheduleAlarm(updatedAlarm);
      } else {
        await _notificationService.cancelAlarm(updatedAlarm);
      }
    } catch (e, s) {
      print('Failed to toggle alarm: $e\n$s');

      alarms[index] = originalAlarm;
      _showErrorSnackbar(AppStrings.errorOccurred);
    }
  }

  void sortAlarmsByTime() {
    alarms.sort((a, b) {
      final aTime = a.hour * 60 + a.minute;
      final bTime = b.hour * 60 + b.minute;
      return aTime.compareTo(bTime);
    });
  }

  Alarm? getAlarmById(String id) {
    return alarms.firstWhereOrNull((alarm) => alarm.id == id);
  }

  bool get hasActiveAlarms => alarms.any((alarm) => alarm.isActive);
  int get activeAlarmsCount => alarms.where((alarm) => alarm.isActive).length;

  void _showBaseSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.md,
      duration: const Duration(seconds: 2),
      animationDuration: AppDurations.medium,
    );
  }

  void _showSuccessSnackbar(String message) {
    _showBaseSnackbar('Success', message, AppColors.success);
  }

  void _showErrorSnackbar(String message) {
    _showBaseSnackbar('Error', message, AppColors.error);
  }

  void showInfoSnackbar(String message) {
    _showBaseSnackbar('Info', message, AppColors.info);
  }
}
