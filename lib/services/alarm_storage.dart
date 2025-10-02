import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/alarm.dart';

class AlarmStorage {
  static const _key = 'alarms';

  Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> alarmStrings = alarms
        .map((alarm) => json.encode(alarm.toJson()))
        .toList();
    await prefs.setStringList(_key, alarmStrings);
  }

  Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? alarmStrings = prefs.getStringList(_key);
    if (alarmStrings == null) {
      return [];
    }
    return alarmStrings.map((s) => Alarm.fromJson(json.decode(s))).toList();
  }
}
