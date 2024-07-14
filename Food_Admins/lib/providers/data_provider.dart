import 'package:flutter/material.dart';
import '../models/sleep.dart';
import '../models/stepdata.dart';
import '../models/calories.dart';
import '../models/exercise.dart';
import '../models/heartrate.dart';
import '../services/impact.dart';

class DataProvider extends ChangeNotifier { 
  // Manage all the data that come from the server.
  // Everything is stored in memory, if the application is closed, data don't exist anymore.

  // This serves as the database of the application
  List<StepData> stepData = [];
  List<Sleep> sleepData = [];
  List<Calories> caloriesData = [];
  List<ExerciseSession> exerciseData = [];
  List<HeartRate> heartData = [];

  // Method to fetch step data from the server
  void fetchStepData(String day) async {
    final data = await ImpactService.fetchStepData(day);
    print('Fetched data: $data');
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        stepData.add(
            StepData.fromJson(data['data']['date'], data['data']['data'][i]));
      }
      notifyListeners();
    }
  }

  // Method to fetch sleep data from the server
  void fetchSleepData(String start, String end) async {
    print('Fetching sleep data');
    final data = await ImpactService.fetchSleepData(start, end);
    print('Fetched data: $data');
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);

    if (data != null && data['data'] != null) {
      for (DateTime date = startDate; date.isBefore(endDate) || date.isAtSameMomentAs(endDate); date = date.add(Duration(days: 1))) {
        print('Processing date: ${formatDate(date)}');
        var dateData = data['data'].firstWhere(
          (item) => item['date'] == formatDate(date),
          orElse: () => null,
        );

        if (dateData != null) {
          print('Data found for date ${formatDate(date)}: $dateData');
        } else {
          print("No data found for date: ${formatDate(date)}");
        }

        if (dateData != null && dateData['data'] != null) {
          if (dateData['data'] is Map<String, dynamic>) {
            try {
              sleepData.add(Sleep.fromJson(dateData['data']));
              print('Added sleep data for date ${formatDate(date)}');
            } catch (e) {
              print('Error parsing sleep data for date ${formatDate(date)}: $e');
            }
          } else {
            print("Invalid data format for date: ${formatDate(date)}, expected a Map");
          }
        } else {
          print("No valid data found for date: ${formatDate(date)}");
        }
      }
      notifyListeners();
    } else {
      print("Failed to fetch sleep data or no data available.");
    }
  }

  // Method to fetch calories data from the server
  void fetchCaloriesData(String day) async {
    print('Fetching calories');
    final data = await ImpactService.fetchCaloriesData(day);
    print('Fetched data: $data');
    
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        caloriesData.add(
            Calories.fromJson(data['data']['date'], data['data']['data'][i]));
      }
    }
    else{
      caloriesData.add(Calories(time: DateTime.parse(day), value: 0.0));
    }
    notifyListeners();
  }

  // Method to fetch heart data from the server
  void fetchHeartData(String start, String end) async {
    print('Fetching heart data');
    final data = await ImpactService.fetchHeartData(start, end);
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);
    if (data != null) {
      for (DateTime date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate); 
          date = date.add(Duration(days: 1))) {
        print(formatDate(date));
        var dateData = data['data']?.firstWhere(
          (item) => item['date'] == formatDate(date),
          orElse: () => null,
        ); 
        print(dateData);
        bool isFound = dateData.toString().contains('data: [{');
        int length = 1; 
        print(dateData['data'].length);
        print(length);
        if (isFound){
          length = dateData['data'].length;
          for (var i = 0; i < length; i++) {
            print(dateData['data'][i]);
            heartData.add(
              HeartRate.fromJson(formatDate(date), dateData['data'][i]));
          }
        } else {
          heartData.add(HeartRate.fromJson(formatDate(date), dateData['data']));
        }
      }
    }
    notifyListeners();
  }

  // Method to fetch exercise data from the server
  void fetchExerciseData(String start, String end) async {
    print('Fetching exercise');
    final data = await ImpactService.fetchExerciseData(start, end);
    print(data);
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);
    if (data != null) {
      for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate); 
        date = date.add(Duration(days: 1))) {
        print(formatDate(date));
        var dateData = data['data']?.firstWhere(
          (item) => item['date'] == formatDate(date),
          orElse: () => null,
        ); 
        print(dateData);
        print(dateData['data'].length);
        for (var i = 0; i < dateData['data'].length; i++) {
          print(dateData['data'][i]);
          exerciseData.add(
            ExerciseSession.fromJson(formatDate(date), dateData['data'][i]));
        }
      }
      notifyListeners();
    }
  }

  // Method to clear the "memory"
  void clearData() {
    stepData.clear();
    sleepData.clear();
    caloriesData.clear();
    exerciseData.clear();
    heartData.clear();
    notifyListeners();
  }
}

String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

