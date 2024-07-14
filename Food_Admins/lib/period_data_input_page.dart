import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wave_clippers.dart';
import 'database_helper.dart';
import 'shared_preferences.dart';
import 'user_profile.dart';

class PeriodDataPage extends StatefulWidget {
  @override
  _PeriodDataPageState createState() => _PeriodDataPageState();
}

class _PeriodDataPageState extends State<PeriodDataPage> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  void _pickDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty ? DateTime.parse(controller.text) : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];  // Formats and sets the date
      });
    }
  }

  void _submitPeriodData() async {
    int userId = await SharedPreferencesManager.getUserId();
    int result = await DatabaseHelper.instance.savePeriodData(
      userId,
      startDateController.text,
      endDateController.text,
    );

    if (result != -1) {
      Map<String, dynamic>? userDetails = await DatabaseHelper.instance.getUserDetails(userId);
      if (userDetails != null && userDetails.containsKey('weight') && userDetails.containsKey('height') && userDetails.containsKey('birthday')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Profile2(userId: userId),
          ),
        );
      } else {
        _showErrorDialog("Failed to retrieve full user details. Please ensure all profile data is complete.");
      }
    } else {
      _showErrorDialog("Error saving period data.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  color: Color(0xFFEED5C7),
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
                  color: Color(0xFF6394AD),
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
                    Text(
                      'Hey, just one little thing!',
                      style: GoogleFonts.dancingScript(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'We need these dates to be anti-anemia buddies together! 🤝🩸',
                      style: GoogleFonts.kreon(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelText: 'Start Date of Your Latest Period',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _pickDate(context, startDateController),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: endDateController,
                      decoration: InputDecoration(
                        labelText: 'End Date of Your Latest Period',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _pickDate(context, endDateController),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitPeriodData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6394AD), // Correct parameter for background color
                        foregroundColor: Colors.white, // Correct parameter for text color
                      ),
                      child: Text('Submit'),
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



