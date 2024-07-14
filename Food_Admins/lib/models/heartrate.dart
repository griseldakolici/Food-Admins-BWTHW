import 'package:intl/intl.dart';
class HeartRate {
  final String date;
  final DateTime time;
  final double value;
  final double error;

  HeartRate(
      {required this.date, required this.time, required this.value, required this.error}); //
  factory HeartRate.fromJson(String date, Map<String, dynamic> json) {
    return HeartRate(
        date : date,
        time: DateFormat('HH:mm:ss').parse('${json['time']}'),
        value: json['value'] ==null ? 0.0 : json['value'].toDouble(),
        error: json['error'] == null? 0.0 : json['error'].toDouble()
      );
  }

  /* int operator [](String key) {
    switch (key) {
      case 'time':
        return time as int;
      case 'value':
        return value;
      case 'confidence':
        return error;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  } */

  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value, confidence: $error)';
  } //toString
}//HeartRate
