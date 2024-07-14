import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_provider.dart';
import 'screens/calories_burned_page.dart';
import 'screens/exercise_page.dart';
import 'screens/heart_rate_page.dart';
import 'wave_clippers.dart';
import 'bottom_navigation_bar.dart';
import 'sleep_data.dart';
import 'package:food_admins_test/mood_tracking.dart';
import 'steps_page.dart';

class Dashboard extends StatelessWidget {
  final int userId;

  Dashboard({required this.userId, Key? key}) : super(key: key);
  static const routename = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          
          Center(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'My data',
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                            color: Color(0xFF49688D),
                            fontSize: 50,
                          ),
                        ),
                        textWidthBasis: TextWidthBasis.parent,
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage('lib/images/HeartBeat.png'),
                                    ),
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (context) => DataProvider(),
                                          child: HeartRatePage(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Heart Rate',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(130.0, 20.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'lib/images/CaloriesBurned.png'),
                                    ),
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (context) => DataProvider(),
                                          child: CaloriesBurned(userId: userId,),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Calories Burned',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(130.0, 20.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage('lib/images/Sleep.png'),
                                    ),
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (context) => DataProvider(),
                                          child: DataScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Sleep',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(130.0, 20.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'lib/images/PhysicalActivity.png'),
                                    ),
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (context) => DataProvider(),
                                          child: ExercisePage(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Physical Activity',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(130.0, 20.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage('lib/images/moodTracking.png'),
                                    ),
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (context) => DataProvider(),
                                          child: MoodTrackingPage(userId: userId),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Mood Tracking',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.9)),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.9)),
                                    
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(130.0, 20.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'lib/images/StepData.png'),
                                    ),
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangeNotifierProvider(
                                          create: (context) => DataProvider(),
                                          child: StepsPage(), // TO CHANGE WITH THE CORRECT PAGE NAME
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Step Data',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.9)),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.9)),
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(130.0, 20.0)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
      bottomNavigationBar: BottomNavBar(userId: userId),
    );
  }
}

