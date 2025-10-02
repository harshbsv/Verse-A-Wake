import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/alarm.dart';
import '../controllers/alarm_controller.dart';
import '../core/constants/app_constants.dart';
import 'add_edit_alarm_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AlarmController controller = Get.put(AlarmController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(controller),
          Obx(() {
            if (controller.isLoading.value && controller.alarms.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            if (controller.alarms.isEmpty) {
              return SliverFillRemaining(
                child: _buildEmptyState(),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final alarm = controller.alarms[index];
                    return _buildAlarmCard(alarm, controller, index);
                  },
                  childCount: controller.alarms.length,
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildAppBar(AlarmController controller) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppStrings.homeTitle,
          style: AppTextStyles.headlineMedium,
        ),
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.lg,
          bottom: AppSpacing.md,
        ),
      ),
      actions: [
        Obx(() => controller.alarms.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => _showClearAllDialog(controller),
                tooltip: 'Clear all alarms',
              )
            : const SizedBox()),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => Get.to(
        () => const AddEditAlarmScreen(),
        transition: Transition.downToUp,
        duration: AppDurations.medium,
      ),
      backgroundColor: AppColors.primary,
      elevation: 8,
      icon: const Icon(Icons.add, color: AppColors.textPrimary),
      label: Text(
        AppStrings.addAlarm,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.alarm_off_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.noAlarmsTitle,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.noAlarmsSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(Alarm alarm, AlarmController controller, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardBackground,
              AppColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: alarm.isActive
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: alarm.isActive
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.to(
              () => AddEditAlarmScreen(alarm: alarm),
              transition: Transition.rightToLeft,
              duration: AppDurations.medium,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.formattedTime,
                          style: AppTextStyles.displaySmall.copyWith(
                            color: alarm.isActive
                                ? AppColors.textPrimary
                                : AppColors.textDisabled,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (alarm.label.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            alarm.label,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: alarm.isActive
                                  ? AppColors.textSecondary
                                  : AppColors.textDisabled,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: alarm.isActive
                                ? AppColors.primary.withOpacity(0.15)
                                : AppColors.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            alarm.repeatDaysString,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: alarm.isActive
                                  ? AppColors.primary
                                  : AppColors.textDisabled,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: alarm.isActive,
                          onChanged: (_) => controller.toggleAlarm(alarm),
                          activeThumbColor: AppColors.primary,
                          activeTrackColor: AppColors.primary.withOpacity(0.5),
                          inactiveThumbColor: AppColors.textDisabled,
                          inactiveTrackColor: AppColors.border,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      IconButton(
                        onPressed: () => _showDeleteDialog(alarm, controller),
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.textTertiary,
                        iconSize: 22,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Alarm alarm, AlarmController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: Text(
          AppStrings.deleteAlarm,
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          AppStrings.deleteAlarmMessage,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.cancel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAlarm(alarm);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Text(
              AppStrings.delete,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void _showClearAllDialog(AlarmController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: Text(
          'Clear All Alarms',
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete all alarms? This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.cancel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearAllAlarms();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Text(
              'Clear All',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
