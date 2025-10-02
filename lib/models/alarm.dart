class Alarm {
  final String id;
  final int hour;
  final int minute;
  final String label;
  final bool isActive;
  final List<int> repeatDays;
  final String ringtone;

  Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    this.label = '',
    this.isActive = true,
    this.repeatDays = const [],
    this.ringtone = 'default',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'label': label,
      'isActive': isActive,
      'repeatDays': repeatDays,
      'ringtone': ringtone,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      hour: json['hour'],
      minute: json['minute'],
      label: json['label'] ?? '',
      isActive: json['isActive'] ?? true,
      repeatDays: List<int>.from(json['repeatDays'] ?? []),
      ringtone: json['ringtone'] ?? 'default',
    );
  }

  Alarm copyWith({
    String? id,
    int? hour,
    int? minute,
    String? label,
    bool? isActive,
    List<int>? repeatDays,
    String? ringtone,
  }) {
    return Alarm(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
      repeatDays: repeatDays ?? this.repeatDays,
      ringtone: ringtone ?? this.ringtone,
    );
  }

  String get timeString {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  String get formattedTime {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }

  String get repeatDaysString {
    if (repeatDays.isEmpty) return 'Once';
    if (repeatDays.length == 7) return 'Every day';

    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final sortedDays = [...repeatDays]..sort();
    return sortedDays.map((day) => dayNames[day]).join(', ');
  }
}
