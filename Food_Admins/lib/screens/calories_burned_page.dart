import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/calories.dart';
import '../database_helper.dart';
import '../wave_clippers.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class CaloriesBurned extends StatefulWidget {
  final int userId;
  CaloriesBurned({Key? key, required this.userId}) : super(key: key);
  @override
  State<CaloriesBurned> createState() => _CaloriesState();
}

class _CaloriesState extends State<CaloriesBurned> {
  double goal = 3000;
  bool fatigue = false;
  List<bool> _weeklyFatigue = List.filled(7, false);
  List<String> last7Days = _getLast7Days();
  String day = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //String day = '2024-05-02';
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchFatigueData();
    _fetchCaloriesData(day);
  }

  Future<void> _fetchUserData() async {
    final userId = widget.userId; 
    Map<String, dynamic>? userDetails = await DatabaseHelper.instance.getUserDetails(userId);
    print('here');
    if (userDetails != null) {
      int weight = userDetails['weight'];
      int height = userDetails['height'];
      String birthdayStr = userDetails['birthday'];
      DateTime birthday = DateFormat('dd.MM.yyyy').parse(birthdayStr);
      int age = calculateAge(birthday);

      print('User details: weight=$weight, height=$height, age=$age');

      // Basic Metabolic Rate (BMR) calculation using the Harris-Benedict equation
      double bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);

      // Activity factor: sedentary = 1.2, lightly active = 1.375, moderately active = 1.55, very active = 1.725, extra active = 1.9
      double activityFactor = 1.55; // Assuming moderately active 
      double calculatedGoal = bmr * activityFactor;

      print('Calculated BMR: $bmr');
      print('Calculated Goal: $calculatedGoal');

      setState(() {
        goal = double.parse(calculatedGoal.toStringAsFixed(2));
      });
    } else {
      print('User details not found.');
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _fetchFatigueData() async {
    List<Map<String, dynamic>> fatigueData = await DatabaseHelper.instance.getFatigueData();
    setState(() {
      for (int i = 0; i < last7Days.length; i++) {
        String date = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 6 - i)));
        _weeklyFatigue[i] = fatigueData.any((element) => element['date'] == date && element['fatigue'] == 1);
      }
    });
  }

  Future<void> _saveFatigueData(int index, bool fatigue) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 6 - index)));
    await DatabaseHelper.instance.saveFatigueData(date, fatigue);
    _fetchFatigueData();
  }

  Future<void> _fetchCaloriesData(String day) async {
    // Implement fetchCaloriesData logic here if needed
    
    Provider.of<DataProvider>(context, listen: false)
                      .fetchCaloriesData(day);
  }

  void _toggleFatigueCompletion(int index) {
    setState(() {
      _weeklyFatigue[index] = !_weeklyFatigue[index];
      _saveFatigueData(index, _weeklyFatigue[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                        ),
                      ),
                      Text(
                        'Calories',
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                            color: Color(0xFF49688D),
                            fontSize: 50
                          ),
                        ),
                        textWidthBasis: TextWidthBasis.parent,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            Provider.of<DataProvider>(context, listen: false)
                              .clearData();
                            _fetchFatigueData();
                            _fetchCaloriesData(day);
                          });
                        },
                        child: Icon(Icons.refresh),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                        ),
                      ),
                    ],
                  ),
                  Text('Today your goal is $goal calories'),
                  // Implement your CaloriesPercentage widget here
                  Consumer<DataProvider>(builder: (context, data, child) {
                      if(data.caloriesData.length==0)
                      {
                        return Container(
                          height: 276,
                          alignment: Alignment.center,
                          child: Text('Loading data', style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                          ),),
                        );
                      }
                      else {
                        return CaloriesPercentage(caloriesData: data.caloriesData, goal: goal);
                      }
                    }
                  ),
                  Row(
                    children: [
                      Text('Are you experiencing unusual fatigue?'),
                      Switch(
                        value: fatigue,
                        onChanged: (bool newfatigue) {
                          setState(() {
                            fatigue = !fatigue;
                            _toggleFatigueCompletion(6);
                          });
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Weekly fatigue report: ',
                    style: TextStyle(color: Color(0xFF49688D), fontSize: 24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      return Column(
                        children: [
                          Text(
                            last7Days[index],
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(height: 10),
                          Icon(
                            _weeklyFatigue[index] ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: _weeklyFatigue[index] ? Colors.green : Colors.grey,
                            size: 30,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  width: 200,
                  height: 150,
                  color: Color(0xFFE15D55),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  width: 300,
                  height: 150,
                  color: Color(0xFF49688D),
                ),
              ),
            ),
            const Positioned(
              bottom: 30,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 130.0),
                      child: Text(
                        'Food Admins',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaloriesPercentage extends StatelessWidget {
  final List<Calories> caloriesData;
  double goal;

  CaloriesPercentage({Key? key, required this.caloriesData, required this.goal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayText;
    double cal = _sumCalories(caloriesData) / goal;
    print('$cal');
    if (cal >= 0 && cal < 0.25) {
      displayText = 'You don\'t have to be great to start, you start to be great!';
    } else if (cal >= 0.25 && cal < 0.5) {
      displayText = 'Keep going!';
    } else if (cal >= 0.5 && cal < 0.75) {
      displayText = 'Every workout brings you one step closer to your goals!';
    } else if (cal >= 0.75 && cal < 1) {
      displayText = 'Don\'t stop until you\'re proud!';
    } else {
      displayText = 'Great job!';
    }
    double perc = _sumCalories(caloriesData) < goal ? _sumCalories(caloriesData) / goal : 1;
    print('$perc');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 20.0,
          percent: perc,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.run_circle_outlined,
                size: 50.0,
                color: Color(0xFF49688D),
              ),
              Text('${double.parse(perc.toStringAsFixed(2)) * 100}%'),
            ],
          ),
          backgroundColor: Color(0xFFEED5C7),
          progressColor: Color(0xFFE15D55),
        ),
        Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFFEED5C7),
          ),
          width: 250,
          child: Text(displayText, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

double _sumCalories(List<Calories> caloriesData) {
  double sum = 0;
  for (Calories c in caloriesData) {
    if (!c.value.isNaN && !c.value.isInfinite){
      sum += c.value;
    }
  }
  print(sum);
  return sum;
}

List<String> _getLast7Days() {
  DateTime now = DateTime.now();
  List<String> days = [];
  for (int i = 6; i >= 0; i--) {
    DateTime day = now.subtract(Duration(days: i));
    days.add(DateFormat('MM/dd').format(day));
  }
  return days;
}


  
