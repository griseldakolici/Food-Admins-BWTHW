import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeriodListPage extends StatelessWidget {
  final Map<DateTime, List<String>> events;
  final List<Map<String, dynamic>> periodData;

  PeriodListPage({required this.events, required this.periodData});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedPeriods = List.from(periodData)
      ..sort((a, b) => DateTime.parse(a['start_date']).compareTo(DateTime.parse(b['start_date'])));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Period History',
          style: GoogleFonts.dancingScript(
            textStyle: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6394AD),
      ),
      body: ListView.builder(
        itemCount: sortedPeriods.length,
        itemBuilder: (context, index) {
          DateTime startDate = DateTime.parse(sortedPeriods[index]['start_date']);
          DateTime endDate = DateTime.parse(sortedPeriods[index]['end_date']);
          int periodDuration = endDate.difference(startDate).inDays + 1;

          return Card(
            color: Colors.white.withOpacity(0.9),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Color(0xFF6394AD), width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Period Start: ${startDate.toLocal().toString().split(' ')[0]}',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49688D),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Period End: ${endDate.toLocal().toString().split(' ')[0]}',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49688D),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Duration: $periodDuration days',
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
      ),
    );
  }
}

