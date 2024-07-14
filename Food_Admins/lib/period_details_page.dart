import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wave_clippers.dart';
import 'database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bottom_navigation_bar.dart';
import 'period_list_page.dart';

class PeriodDetailsPage extends StatefulWidget {
  final int userId;

  PeriodDetailsPage({required this.userId});

  @override
  _PeriodDetailsPageState createState() => _PeriodDetailsPageState();
}

class _PeriodDetailsPageState extends State<PeriodDetailsPage> {
  bool isLoading = true;
  int? lastPeriodDuration;
  DateTime? lastStartDate;
  DateTime? nextPeriodStart;
  String? anemiaRisk;
  String? cycleNormality;
  late Map<DateTime, List<String>> _events;
  List<Map<String, dynamic>> periodData = [];

  @override
  void initState() {
    super.initState();
    _events = {};
    _fetchPeriodDetails();
    _fetchPeriodData();
  }

  Future<void> _fetchPeriodDetails() async {
    try {
      var details = await DatabaseHelper.instance.getPeriodDetails(widget.userId);

      if (details != null) {
        setState(() {
          lastPeriodDuration = details['lastEndDate'] == null
              ? DateTime.now().difference(details['lastStartDate']).inDays
              : details['lastEndDate'].difference(details['lastStartDate']).inDays;
          lastStartDate = details['lastStartDate'];
          anemiaRisk = _determineAnemiaRisk(lastPeriodDuration!);
          nextPeriodStart = details['lastCycleLength'] != null
              ? _predictNextPeriod(details['lastStartDate'], details['lastCycleLength'])
              : _predictNextPeriod(details['lastStartDate'], 28); // Default to 28 days
          cycleNormality = details['cycleNormality'];
          isLoading = false;
        });
      } else {
        setState(() {
          anemiaRisk = 'Not enough data';
          cycleNormality = 'Not enough data';
          nextPeriodStart = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching period details: $e');
      setState(() {
        anemiaRisk = 'Error fetching data';
        cycleNormality = 'Error fetching data';
        nextPeriodStart = null;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchPeriodData() async {
    DateTime now = DateTime.now();
    String startDate = DateTime(now.year, now.month - 6, now.day).toString(); // Fetch data for the last 6 months
    String endDate = now.toString();

    print('Fetching period data from $startDate to $endDate');

    periodData = await DatabaseHelper.instance.getPeriodDataForDateRange(widget.userId, startDate, endDate);

    print('Period data fetched: $periodData');

    setState(() {
      for (var period in periodData) {
        DateTime start = DateTime.parse(period['start_date']);
        DateTime end = period['end_date'] != null ? DateTime.parse(period['end_date']) : now;

        print('Processing period from $start to $end');

        for (var date = start; date.isBefore(end) || date.isAtSameMomentAs(end); date = date.add(Duration(days: 1))) {
          if (_events[date] != null) {
            _events[date]!.add('Period');
          } else {
            _events[date] = ['Period'];
          }

          print('Added event for date: $date');
        }
      }
    });

    print('Events: $_events');
  }

  String _determineAnemiaRisk(int periodDuration) {
    if (periodDuration > 7) {
      return 'High risk for anemia. Consider consulting a doctor.';
    } else if (periodDuration >= 4) {
      return 'Normal risk for anemia.';
    } else {
      return 'Low risk for anemia.';
    }
  }

  DateTime _predictNextPeriod(DateTime lastStartDate, int cycleLength) {
    return lastStartDate.add(Duration(days: cycleLength));
  }

  Future<void> _handleAddNewPeriodData(BuildContext context) async {
    print("Add New Period Data button pressed");

    var lastPeriodEntry = await DatabaseHelper.instance.getLastPeriodEntry(widget.userId);

    if (lastPeriodEntry == null || lastPeriodEntry['end_date'] != null) {
      // Prompt user for new period start date
      DateTime? newStartDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialDate: DateTime.now(),
      );

      if (newStartDate != null) {
        print("New start date picked: $newStartDate");
        await DatabaseHelper.instance.savePeriodData(widget.userId, newStartDate.toString(), null);
        _fetchPeriodDetails();
        _fetchPeriodData();
      } else {
        print("No start date picked");
      }
    } else {
      // Prompt user for end date of the current period
      DateTime? newEndDate = await showDatePicker(
        context: context,
        firstDate: DateTime.parse(lastPeriodEntry['start_date']),
        lastDate: DateTime.now(),
        initialDate: DateTime.now(),
      );

      if (newEndDate != null) {
        print("New end date picked: $newEndDate");
        await DatabaseHelper.instance.updatePeriodEndDate(widget.userId, lastPeriodEntry['id'], newEndDate.toString());
        _fetchPeriodDetails();
        _fetchPeriodData();
      } else {
        print("No end date picked");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEFE),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: TopWaveClipper(),
                      child: Container(
                        width: 200,
                        height: 150,
                        color: const Color(0xFFEED5C7),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Period Details',
                                  style: GoogleFonts.dancingScript(
                                    fontSize: 32,
                                    color: Color(0xFF49688D),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          Image.asset(
                            'lib/images/period_details.png', // Ensure you have this image asset
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 1),
                          _buildInfoContainer(
                            icon: FontAwesomeIcons.calendarDay,
                            title: 'Last Period Data',
                            value: lastPeriodDuration != null
                                ? '$lastPeriodDuration days'
                                : 'No data available',
                            color: Color(0xFF6394AD),
                          ),
                          SizedBox(height: 10),
                          _buildInfoContainer(
                            icon: FontAwesomeIcons.tint,
                            title: 'Anemia Risk',
                            value: anemiaRisk ?? 'No data available',
                            color: anemiaRisk == 'High risk for anemia. Consider consulting a doctor.'
                                ? Colors.redAccent
                                : Color(0xFF6394AD),
                          ),
                          SizedBox(height: 10),
                          _buildInfoContainer(
                            icon: FontAwesomeIcons.balanceScale,
                            title: 'Cycle Normality',
                            value: cycleNormality ?? 'No data available',
                            color: cycleNormality == 'Normal'
                                ? Colors.green
                                : cycleNormality == 'Atypical'
                                    ? Colors.redAccent
                                    : Color(0xFF6394AD),
                          ),
                          SizedBox(height: 10),
                          _buildInfoContainer(
                            icon: FontAwesomeIcons.calendarAlt,
                            title: 'Next Predicted Period Start',
                            value: nextPeriodStart != null
                                ? '${nextPeriodStart!.toLocal().toString().split(' ')[0]}'
                                : 'No data available',
                            color: Color(0xFF6394AD),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              print("Add New Period Data button pressed");
                              _handleAddNewPeriodData(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6394AD),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text('Add New Period Data'),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PeriodListPage(events: _events, periodData: periodData),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6394AD),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text('View Period History'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavBar(userId: widget.userId),
    );
  }

  Widget _buildInfoContainer({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}















