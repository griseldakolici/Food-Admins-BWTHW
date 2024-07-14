import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'models/mood.dart';
import 'wave_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodHistoryPage extends StatelessWidget {
  final int userId;

  MoodHistoryPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEFE),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  width: 200,
                  height: 150,
                  color: const Color(0xFFE15D55),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      BackButton(),
                      Expanded(
                        child: Text(
                          'Mood History',
                          style: GoogleFonts.dancingScript(
                            fontSize: 32,
                            color: Color(0xFF49688D),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Anemia can make us feel tired and other symptoms sometimes. Here is your mood tracking data for the last 30 days:',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<Mood>>(
                      future: _fetchMoodData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No mood data available'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final mood = snapshot.data![index];
                              return Card(
                                color: Colors.white.withOpacity(0.9),
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Color(0xFF6394AD), width: 1.5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${mood.date} - ${mood.mood}',
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF49688D),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        mood.notes ?? 'No additional notes',
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Mood>> _fetchMoodData() async {
    DateTime now = DateTime.now();
    String startDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 30)));
    String endDate = DateFormat('yyyy-MM-dd').format(now);
    return await DatabaseHelper.instance.getMoodDataForDateRange(userId, startDate, endDate);
  }
}





