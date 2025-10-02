import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm.dart';

class AlarmStorage {
  static const String _alarmsKey = 'alarms';

  // Save all alarms to storage
  Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = alarms.map((alarm) => alarm.toJson()).toList();
    final alarmsString = jsonEncode(alarmsJson);
    await prefs.setString(_alarmsKey, alarmsString);
  }

  // Load all alarms from storage
  Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsString = prefs.getString(_alarmsKey);
    
    if (alarmsString == null || alarmsString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> alarmsJson = jsonDecode(alarmsString);
      return alarmsJson
          .map((json) => Alarm.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log error silently in production
      return [];
    }
  }

  // Add a new alarm
  Future<void> addAlarm(Alarm alarm) async {
    final alarms = await loadAlarms();
    alarms.add(alarm);
    await saveAlarms(alarms);
  }

  // Update an existing alarm
  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final alarms = await loadAlarms();
    final index = alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    
    if (index != -1) {
      alarms[index] = updatedAlarm;
      await saveAlarms(alarms);
    }
  }

  // Delete an alarm
  Future<void> deleteAlarm(String alarmId) async {
    final alarms = await loadAlarms();
    alarms.removeWhere((alarm) => alarm.id == alarmId);
    await saveAlarms(alarms);
  }

  // Toggle alarm active state
  Future<void> toggleAlarm(String alarmId) async {
    final alarms = await loadAlarms();
    final index = alarms.indexWhere((alarm) => alarm.id == alarmId);
    
    if (index != -1) {
      alarms[index] = alarms[index].copyWith(isActive: !alarms[index].isActive);
      await saveAlarms(alarms);
    }
  }

  // Clear all alarms
  Future<void> clearAllAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_alarmsKey);
  }
}
