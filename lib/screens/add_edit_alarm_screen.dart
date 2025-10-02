import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/alarm.dart';
import '../controllers/alarm_controller.dart';
import '../core/constants/app_constants.dart';

class AddEditAlarmScreen extends StatelessWidget {
  final Alarm? alarm;

  const AddEditAlarmScreen({super.key, this.alarm});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlarmController>();
    final labelController = TextEditingController(
      text: alarm?.label ?? '',
    );
    
    final selectedHour = (alarm?.hour ?? TimeOfDay.now().hour).obs;
    final selectedMinute = (alarm?.minute ?? TimeOfDay.now().minute).obs;
    final selectedDays = (alarm?.repeatDays.toSet() ?? <int>{}).obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTimePicker(context, selectedHour, selectedMinute),
                  const SizedBox(height: AppSpacing.xl),
                  _buildLabelInput(labelController),
                  const SizedBox(height: AppSpacing.xl),
                  _buildRepeatDaysSection(selectedDays),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSaveButton(
                    controller,
                    labelController,
                    selectedHour,
                    selectedMinute,
                    selectedDays,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          alarm != null ? AppStrings.editAlarm : AppStrings.addAlarm,
          style: AppTextStyles.headlineSmall,
        ),
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.xxl + AppSpacing.lg,
          bottom: AppSpacing.md,
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    RxInt selectedHour,
    RxInt selectedMinute,
  ) {
    return Obx(() {
      final hour = selectedHour.value;
      final minute = selectedMinute.value;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final minuteStr = minute.toString().padLeft(2, '0');

      return GestureDetector(
        onTap: () => _pickTime(context, selectedHour, selectedMinute),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cardBackground,
                AppColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$displayHour:$minuteStr',
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    period,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.tapToChangeTime,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _pickTime(
    BuildContext context,
    RxInt selectedHour,
    RxInt selectedMinute,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: selectedHour.value, minute: selectedMinute.value),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedHour.value = picked.hour;
      selectedMinute.value = picked.minute;
    }
  }

  Widget _buildLabelInput(TextEditingController labelController) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: labelController,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          labelText: AppStrings.alarmLabel,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          hintText: AppStrings.alarmLabelHint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textDisabled,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppSpacing.lg),
          prefixIcon: Icon(
            Icons.label_outline,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatDaysSection(RxSet<int> selectedDays) {
    const days = [
      {'name': AppStrings.sunday, 'value': 0},
      {'name': AppStrings.monday, 'value': 1},
      {'name': AppStrings.tuesday, 'value': 2},
      {'name': AppStrings.wednesday, 'value': 3},
      {'name': AppStrings.thursday, 'value': 4},
      {'name': AppStrings.friday, 'value': 5},
      {'name': AppStrings.saturday, 'value': 6},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.repeat,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              final dayValue = day['value'] as int;
              final isSelected = selectedDays.contains(dayValue);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    selectedDays.remove(dayValue);
                  } else {
                    selectedDays.add(dayValue);
                  }
                },
                child: AnimatedContainer(
                  duration: AppDurations.medium,
                  curve: Curves.easeInOut,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day['name'] as String,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildSaveButton(
    AlarmController controller,
    TextEditingController labelController,
    RxInt selectedHour,
    RxInt selectedMinute,
    RxSet<int> selectedDays,
  ) {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return ElevatedButton(
        onPressed: isLoading
            ? null
            : () => _saveAlarm(
                  controller,
                  labelController,
                  selectedHour,
                  selectedMinute,
                  selectedDays,
                ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.textPrimary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                alarm != null ? AppStrings.updateAlarm : AppStrings.saveAlarm,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );
    });
  }

  Future<void> _saveAlarm(
    AlarmController controller,
    TextEditingController labelController,
    RxInt selectedHour,
    RxInt selectedMinute,
    RxSet<int> selectedDays,
  ) async {
    final newAlarm = Alarm(
      id: alarm?.id ?? const Uuid().v4(),
      hour: selectedHour.value,
      minute: selectedMinute.value,
      label: labelController.text.trim(),
      isActive: true,
      repeatDays: selectedDays.toList()..sort(),
    );

    bool success;
    if (alarm != null) {
      success = await controller.updateAlarm(newAlarm);
    } else {
      success = await controller.addAlarm(newAlarm);
    }

    if (success) {
      Get.back(result: true);
    }
  }
}
