import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import 'package:intl/intl.dart';
import '../wave_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

class StepsPage extends StatefulWidget {
  StepsPage({Key? key}) : super(key: key);

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  final String day = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool isAlert = false;

  @override
  void initState() {
    super.initState();
    // Fetch the data once when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.fetchStepData(day);
      dataProvider.fetchStepData(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(day).subtract(Duration(days: 1))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
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
                      'Steps Over Time',
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          color: Color(0xFF49688D),
                          fontSize: 40,
                        ),
                      ),
                      textWidthBasis: TextWidthBasis.parent,
                    ),
                  ],
                ),
                Consumer<DataProvider>(builder: (context, dataProvider, child) {
                  // Filter the data to include only the steps from 20:00 (8 PM) to 08:00 (8 AM)
                  List<FlSpot> filteredSpots = dataProvider.stepData
                      .where((e) =>
                          (e.time.hour >= 20 &&
                              DateFormat('yyyy-MM-dd').format(e.time) != day) ||
                          (e.time.hour < 8 &&
                              DateFormat('yyyy-MM-dd').format(e.time) == day))
                      .map((e) => FlSpot(
                          e.time.millisecondsSinceEpoch.toDouble(),
                          e.value.toDouble()))
                      .toList();

                  if (filteredSpots.isEmpty) {
                    return Center(
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(12),
                        color: Colors.red,
                        child: Text(
                          'ERROR! Data are not available here! Please start wearing your smartwatch!',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    );
                  } else {
                    return Column(children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 20,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 2 * 60 * 60 * 1000.toDouble(),
                                  // 2 hours in milliseconds
                                  getTitlesWidget: (value, meta) {
                                    final date = DateTime
                                        .fromMillisecondsSinceEpoch(
                                            value.toInt());
                                    final formattedDate =
                                        DateFormat('HH:mm').format(date);
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: filteredSpots,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 2,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            minX: DateTime.parse(day)
                                .subtract(Duration(days: 1))
                                .add(Duration(hours: 20))
                                .millisecondsSinceEpoch
                                .toDouble(),
                            maxX: DateTime.parse(day)
                                .add(Duration(hours: 8))
                                .millisecondsSinceEpoch
                                .toDouble(),
                            minY: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Restless Leg Syndrome',
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                            color: Color(0xFF49688D),
                            fontSize: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'If you experience leg movements during the night, it might be affecting your sleep quality. Walking regularly can help improve this condition.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]);
                  }
                }),
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
        ],
      ),
    );
  }
}
