import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../wave_clippers.dart';
import 'package:intl/intl.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch sleep data when the widget is initialized
    String yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  
    Provider.of<DataProvider>(context, listen: false).fetchSleepData(yesterday, today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEFE),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        'Sleep Data',
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
                  SizedBox(height: 20),
                  sleepStageGraph(context),
                  SizedBox(height: 20),
                  sleepSummary(context),
                  SizedBox(height: 20),
                  sleepEfficiency(context),
                  SizedBox(height: 10),
                  sleepDetails(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sleepStageGraph(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        if (dataProvider.sleepData.isEmpty) {
          return Text('No sleep data available', style: TextStyle(color: Color(0xFF49688D)));
        }

        final sleepSummary = dataProvider.sleepData[0].levels?['summary'];

        if (sleepSummary == null) {
          return Text('No sleep levels available', style: TextStyle(color: Color(0xFF49688D)));
        }

        return Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(color: Colors.blue[200], height: 25),
                    flex: sleepSummary['wake']['minutes'],
                  ),
                  Expanded(
                    child: Container(color: Colors.blue[400], height: 25),
                    flex: sleepSummary['rem']['minutes'],
                  ),
                  Expanded(
                    child: Container(color: Colors.blue[600], height: 25),
                    flex: sleepSummary['light']['minutes'],
                  ),
                  Expanded(
                    child: Container(color: Colors.blue[800], height: 25),
                    flex: sleepSummary['deep']['minutes'],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                legendItem(Colors.blue[200]!, 'Awake'),
                legendItem(Colors.blue[400]!, 'REM'),
                legendItem(Colors.blue[600]!, 'Light'),
                legendItem(Colors.blue[800]!, 'Deep'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Icon(Icons.square, color: color, size: 24),
        SizedBox(width: 8),
        Text(text, style: TextStyle(color: Color(0xFF49688D))),
      ],
    );
  }

  Widget sleepSummary(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final totalSleep = dataProvider.sleepData.isNotEmpty
            ? formatDuration(calculateTotalSleep(dataProvider.sleepData[0].levels))
            : '0h 0m';
        final timeInBed = dataProvider.sleepData.isNotEmpty
            ? formatDuration(dataProvider.sleepData[0].timeInBed?.toDouble())
            : '0h 0m';

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: sleepCard('Total Sleep', totalSleep),
                ),
                Expanded(
                  child: sleepCard('Time in Bed', timeInBed),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: sleepCard('Sleep Score', calculateSleepScore(dataProvider)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget sleepEfficiency(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final efficiency = dataProvider.sleepData.isNotEmpty ? dataProvider.sleepData[0].efficiency.toString() + '%' : 'N/A';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sleep Efficiency', style: GoogleFonts.cabin(color: Color(0xFF49688D), fontSize: 20)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: dataProvider.sleepData.isNotEmpty && dataProvider.sleepData[0].efficiency != null ? dataProvider.sleepData[0].efficiency! / 100 : 0,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6394AD)),
            ),
            SizedBox(height: 5),
            Text(efficiency, style: TextStyle(color: Color(0xFF49688D), fontSize: 16)),
          ],
        );
      },
    );
  }

  Widget sleepDetails(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        if (dataProvider.sleepData.isEmpty) {
          return Text('No sleep data available', style: TextStyle(color: Color(0xFF49688D)));
        }

        final totalSleep = formatDuration(calculateTotalSleep(dataProvider.sleepData[0].levels));
        final efficiency = dataProvider.sleepData[0].efficiency.toString() + '%';
        final remSleep = formatDuration(dataProvider.sleepData[0].levels?['summary']?['rem']?['minutes']?.toDouble());
        final deepSleep = formatDuration(dataProvider.sleepData[0].levels?['summary']?['deep']?['minutes']?.toDouble());
        final lightSleep = formatDuration(dataProvider.sleepData[0].levels?['summary']?['light']?['minutes']?.toDouble());
        final awakeSleep = formatDuration(dataProvider.sleepData[0].levels?['summary']?['wake']?['minutes']?.toDouble());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sleep Contributors', style: GoogleFonts.cabin(color: Color(0xFF49688D), fontSize: 20)),
            SizedBox(height: 10),
            sleepStat('Total Sleep', totalSleep),
            sleepStat('Efficiency', efficiency),
            sleepStat('Awake Sleep', awakeSleep),
            sleepStat('REM Sleep', remSleep),
            sleepStat('Light Sleep', lightSleep),
            sleepStat('Deep Sleep', deepSleep),
          ],
        );
      },
    );
  }

  Widget sleepCard(String title, String value) {
    return Card(
      color: Color(0xFFEED5C7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: Color(0xFF49688D), fontSize: 14)),
            SizedBox(height: 10),
            Text(value, style: TextStyle(color: Color(0xFF49688D), fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget sleepStat(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Color(0xFF49688D), fontSize: 14)),
          Text(value, style: TextStyle(color: Color(0xFF49688D), fontSize: 14)),
        ],
      ),
    );
  }

  String formatDuration(double? duration) {
    if (duration == null) return '0h 0m';
    final int durationInMinutes = duration.toInt();
    final int hours = durationInMinutes ~/ 60;
    final int minutes = durationInMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  double calculateTotalSleep(Map<String, dynamic>? levels) {
    if (levels == null) return 0;
    final summary = levels['summary'] ?? {};
    final int deep = summary['deep']?['minutes'] ?? 0;
    final int light = summary['light']?['minutes'] ?? 0;
    final int rem = summary['rem']?['minutes'] ?? 0;
    final int wake = summary['wake']?['minutes'] ?? 0;
    return (deep + light + rem + wake).toDouble();
  }

  String calculateSleepScore(DataProvider dataProvider) {
    if (dataProvider.sleepData.isEmpty) return 'N/A';

    final sleep = dataProvider.sleepData[0];
    if (sleep.efficiency == null || sleep.minutesAwake == null || sleep.timeInBed == null) {
      return 'N/A';
    }

    final efficiencyScore = sleep.efficiency!;
    final awakePenalty = (sleep.minutesAwake! / sleep.timeInBed!) * 100;
    final score = efficiencyScore - awakePenalty;

    return score.toStringAsFixed(0);
  }
}



