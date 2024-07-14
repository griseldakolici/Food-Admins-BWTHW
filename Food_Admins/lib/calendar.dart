import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Date for Exercise Details')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchDataForSelectedDate(selectedDay);
            },
          ),
        ],
      ),
    );
  }

  void _fetchDataForSelectedDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    Provider.of<DataProvider>(context, listen: false)
        .fetchExerciseData(formattedDate, formattedDate);
    _showDataDialog();
  }

  void _showDataDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Exercise Data for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}'),
        content: Consumer<DataProvider>(
          builder: (context, data, child) {
            if (data.exerciseData.isEmpty) {
              return Text('No data available for this date.');
            }
            return Container(
              width: double.maxFinite, // Ensures the container tries to fill the dialog width
              child: ListView.builder(
                shrinkWrap: true, // Ensures the ListView only occupies the space it needs
                itemCount: data.exerciseData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data.exerciseData[index].activityName),
                    subtitle: Text(data.exerciseData[index].date),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
}