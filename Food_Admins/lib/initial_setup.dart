import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wave_clippers.dart';
import 'database_helper.dart';
import 'shared_preferences.dart';
import 'period_data_input_page.dart';

class InitialSetupPage extends StatefulWidget {
  @override
  _InitialSetupPageState createState() => _InitialSetupPageState();
}

class _InitialSetupPageState extends State<InitialSetupPage> {
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submitProfileData() async {
    int userId = SharedPreferencesManager.getUserId(); // Retrieve user ID from SharedPreferences
    if (userId != 0) {
      await DatabaseHelper.instance.completeUserProfile(
        userId,
        birthdayController.text,
        int.parse(weightController.text),
        int.parse(heightController.text),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PeriodDataPage(
          ),
        ),
      );
    } else {
      // Handle user not found or user ID not set in SharedPreferences
      print("User ID not found, please log in again.");
    }
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to Food Admins!',
                      style: GoogleFonts.dancingScript(
                        fontSize: 32,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Please provide your data to set up your profile.',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    InputFieldWithIcon(
                      icon: Icons.monitor_weight,
                      label: 'Weight (kg)',
                      side: BorderSide(color: Color(0xFF6394AD), width: 2),
                      iconColor: Color(0xFFE15D55),
                      controller: weightController,
                    ),
                    SizedBox(height: 16),
                    InputFieldWithIcon(
                      icon: Icons.height,
                      label: 'Height (cm)',
                      side: BorderSide(color: Color(0xFF6394AD), width: 2),
                      iconColor: Color(0xFFE15D55),
                      controller: heightController,
                    ),
                    SizedBox(height: 16),
                    InputFieldWithIcon(
                      icon: Icons.cake,
                      label: 'Birthday',
                      side: BorderSide(color: Color(0xFF6394AD), width: 2),
                      iconColor: Color(0xFFE15D55),
                      controller: birthdayController,
                      onTap: () => _pickDate(context),
                    ),
                    SizedBox(height: 32),
                    Container(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _submitProfileData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF6394AD), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Color(0xFF6394AD)),
                          ),
                        ),
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

class InputFieldWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final BorderSide side;
  final Color iconColor;
  final TextEditingController controller;
  final VoidCallback? onTap;

  const InputFieldWithIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.side,
    required this.iconColor,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: iconColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: iconColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: iconColor, width: 2),
                ),
              ),
              keyboardType: TextInputType.number, // Ensure this is number for weight and height
              textInputAction: TextInputAction.next, // Adds a 'next' button on the keyboard
            ),
          ),
        ],
      ),
    );
  }
}

