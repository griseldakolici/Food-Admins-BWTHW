class Sleep {
  final String? logId;
  final String? dateOfSleep;
  final String? startTime;
  final String? endTime;
  final double? duration;
  final double? efficiency;
  final int? minutesToFallAsleep;
  final int? minutesAwake;
  final int? minutesAfterWakeUp;
  final int? timeInBed;
  final String? type;
  final int? infoCode;
  final String? logType;
  final bool? mainSleep;
  final Map<String, dynamic>? levels;

  Sleep({
    required this.logId,
    required this.dateOfSleep,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.efficiency,
    required this.minutesToFallAsleep,
    required this.minutesAwake,
    required this.minutesAfterWakeUp,
    required this.timeInBed,
    required this.type,
    required this.infoCode,
    required this.logType,
    required this.mainSleep,
    required this.levels,
  });

  factory Sleep.fromJson(Map<String?, dynamic> json) {
    return Sleep(
      logId: json['logId'],
      dateOfSleep: json['dateOfSleep'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: (json['duration'] as num?)?.toDouble(),
      efficiency: (json['efficiency'] as num?)?.toDouble(),
      minutesToFallAsleep: json['minutesToFallAsleep'],
      minutesAwake: json['minutesAwake'],
      minutesAfterWakeUp: json['minutesAfterWakeUp'],
      timeInBed: json['timeInBed'],
      type: json['type'],
      infoCode: json['infoCode'],
      logType: json['logType'],
      mainSleep: json['mainSleep'],
      levels: json['levels'] != null ? json['levels'] as Map<String, dynamic> : null,
    );
  }

  @override
  String toString() {
    return 'Sleep(logId: $logId, dateOfSleep: $dateOfSleep, startTime: $startTime, endTime: $endTime, duration: $duration, efficiency: $efficiency, minutesToFallAsleep: $minutesToFallAsleep, minutesAwake: $minutesAwake, minutesAfterWakeUp: $minutesAfterWakeUp, timeInBed: $timeInBed, type: $type, infoCode: $infoCode, logType: $logType, mainSleep: $mainSleep, levels: $levels)';
  }
}
