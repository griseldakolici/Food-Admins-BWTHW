class ExerciseSession {
  final String date;
  final String activityName;
  final double averageHeartRate;
  final double calories;
  final double distance;
  final String distanceUnit;
  final double duration;
  final double activeDuration;
  final int steps;
  final String logType;
  final List<dynamic> heartRateZones;
  final double speed;
  final double vo2max;
  final double elevationGain;
  final String time;

  ExerciseSession({
    required this.date,
    required this.activityName,
    required this.averageHeartRate,
    required this.calories,
    required this.distance,
    required this.distanceUnit,
    required this.duration,
    required this.activeDuration,
    required this.steps,
    required this.logType,
    required this.heartRateZones,
    required this.speed,
    required this.vo2max,
    required this.elevationGain,
    required this.time,
  });

  factory ExerciseSession.fromJson(String data, Map<String, dynamic> json) {
    return ExerciseSession(
      date: data,
      activityName: json['activityName'],
      averageHeartRate: json['averageHeartRate'] == null ? 0.0 : json['averageHeartRate'].toDouble(),
      calories: json['calories']==null ?  0.0 : json['calories'].toDouble(),
      distance: json['distance'] == null ? 0.0 : json['distance'].toDouble(),
      distanceUnit: json['distanceUnit'] ?? '',
      duration: json['duration'] != null ? json['duration'].toDouble() : 0.0,
      activeDuration: json['activeDuration'] != null ? json['activeDuration'].toDouble() : 0.0,
      steps: json['steps'] ?? 0,
      logType: json['logType'] ?? '',
      heartRateZones: json['heartRateZones'] ?? [],
      speed: json['speed'] == null ? 0.0 : json['speed'].toDouble(),
      vo2max: json['vo2max'] != null ? json['vo2max'].toDouble() : 0.0,
      elevationGain: json['elevationGain'] != null ? json['elevationGain'].toDouble() : 0.0,
      time: json['time'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ExerciseSession(activityName: $activityName, averageHeartRate: $averageHeartRate, calories: $calories, '
        'distance: $distance, distanceUnit: $distanceUnit, duration: $duration, activeDuration: $activeDuration, '
        'steps: $steps, logType: $logType, heartRateZones: $heartRateZones, speed: $speed, vo2max: $vo2max, '
        'elevationGain: $elevationGain, time: $time)';
  }
}
