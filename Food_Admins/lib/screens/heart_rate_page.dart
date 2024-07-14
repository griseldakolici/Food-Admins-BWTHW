import '/services/impact.dart';
import 'package:google_fonts/google_fonts.dart';
import '/wave_clippers.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import '../providers/data_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/heartrate.dart';

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  String start = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 6)));
  String end = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //String start = '2023-04-04';
  //String end = '2023-04-10';
  List<double> hrValues = [];
  List<double> hrValue = [];
  final List<String> last7Days = _getLast7Days();
  bool isAlert = true;
  @override
  Widget build(BuildContext context) {
    //Provider.of<DataProvider>(context, listen: false)
                        //.clearData();
    Provider.of<DataProvider>(context, listen: false)
                        .fetchHeartData(start, end); 
    print(last7Days.toString());
    return MaterialApp(home:  Scaffold(
      body: Stack(
        children: [Container(
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
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
                  style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                ),
              ), 
              Text(
                'Heart Rate', 
                style: GoogleFonts.dancingScript(textStyle: TextStyle(color: Color(0xFF49688D), fontSize: 50),),
                textWidthBasis: TextWidthBasis.parent,
              ),
              ]
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Color(0xFFEED5C7),
              alignment: Alignment.center,
              child: Text('Anemia can cause your heart rate to increase as your heart works harder to pump oxygen-rich blood throughout your body')
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
              child: Text('Your weekly resting HR report: ', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),)
            ),
            Consumer<DataProvider>(builder: (context, data, child) {
              hrValue = calculateDailyAverage(data.heartData, start, end);
              print(hrValue.toString());
              List<double> hrValues = hrValue.map((value) {
                  if (value.isNaN || value.isInfinite) {
                    return 0.0;  // Imposta a 0.0 se è NaN o infinito
                  } else {
                    return value;  // Mantieni il valore originale se è valido
                  }
                }).toList();
              double meanHr = weeklyMean(hrValues);
              //double meanHr = 100;
              isAlert = meanHr > 80 || meanHr < 40;
              
              if (meanHr == 0) {
                  return Center(
                    child: Container( 
                      width: 300,
                      padding: EdgeInsets.all(12),
                      color: Colors.red,
                      child: Text(
                      'ERROR! Data are not available here! Please start wearing your smartwatch!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    )
                  );
                }
              else{
              return Column( children: [Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  minY: 0,
                  gridData: FlGridData(
                    horizontalInterval: 1.0,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    checkToShowHorizontalLine: (value) {
                      return value == meanHr.ceilToDouble();
                    },
                    getDrawingHorizontalLine: (value) {
                      if (value == meanHr.ceilToDouble() && isAlert == false) {
                        return const FlLine(
                          color: Colors.green,
                          strokeWidth: 2,
                        );
                      }
                      else {
                        return const FlLine(
                          color: Colors.red,
                          strokeWidth: 0.5,
                        );
                      }
                    }
                  ),
                  barGroups: List.generate(hrValues.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: hrValues[index],
                          color: Color(0xFFE15D55),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 30,
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        );
                        Widget text;
                        if (value.toInt() >= 0 && value.toInt() < last7Days.length) {
                        text = Text(last7Days[value.toInt()], style: style);
                      } else {
                        text = Text('', style: style);
                      }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8.0,
                          child: text,
                        );
                    }
                ),
              ),
            ),
            ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(60, 197, 195, 195),
                borderRadius: BorderRadius.all(Radius.circular(12))),
              
              padding: const EdgeInsets.all(8.0),
              child: isAlert ? Text(
                "Warning: Weekly Average HR Exceeds 80!",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ) : Text('Your Heart rate is in a good range!', 
                  style: TextStyle(color: Colors.green, fontSize: 16)),
            ),
            ]
            );
              } //else
            }
            ),
            
            ]
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
           color: Color(0xFFE15D55 ),
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
               color: Color(0xFF49688D ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 130.0),
                  child: TextButton(
                    child: Text('Food Admins', style: TextStyle(color: Colors.black, fontSize: 16)),
                    onPressed: () async {
                      final result = await ImpactService.authorize();
                      final message =
                          result == 200 ? 'Request successful' : 'Request failed';
                      print(message);
                    },
                  ),
                ),]
              )
            )
          )
          ],
      )
      )
    );
  }
}
double weeklyMean(List<double> hrValues){
  if (hrValues.isEmpty) {
      return 0.0;
    }
    double sum = hrValues.reduce((a, b) => a + b);
    return sum / hrValues.length;
}

List<double> calculateDailyAverage(List<HeartRate> HeartRateData, String start, String end) {
    List<double> dailyAverage = [];
    double sum = 0;
    int c = 0; 
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);
    for (DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate); 
      date = date.add(Duration(days: 1))) {
        //print(formatDate(date));
        sum = 0; 
        c = 0;
        HeartRateData.forEach((data) {
          if (formatDate(date)==data.date){
            sum += data.value;
            c = c+1;
          }
        });
        dailyAverage.add(sum/c);

      }
    
    return dailyAverage;
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