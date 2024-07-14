import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'shared_preferences.dart';
import 'login_page.dart';
import 'wave_clippers.dart';
import 'bottom_navigation_bar.dart';
import 'package:intl/intl.dart';

class Profile2 extends StatefulWidget {
  final int userId;

  Profile2({Key? key, required this.userId}) : super(key: key);

  @override
  State<Profile2> createState() => _ProfileState2();
}

class _ProfileState2 extends State<Profile2> {
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController birthdayController;
  late TextEditingController usernameController;
  bool _isLoading = true;
  double? _bmi;
  String _bmiStatus = 'No data available';
  Color _bmiColor = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController();
    heightController = TextEditingController();
    birthdayController = TextEditingController();
    usernameController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await DatabaseHelper.instance.getUserDetails(widget.userId);
    if (userData != null) {
      setState(() {
        usernameController.text = userData['username'] ?? '';
        weightController.text = userData['weight']?.toString() ?? '';
        heightController.text = userData['height']?.toString() ?? '';
        birthdayController.text = userData['birthday'] ?? '';
        _calculateBMI();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateBMI() {
    if (weightController.text.isNotEmpty && heightController.text.isNotEmpty) {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100; // convert cm to meters
      _bmi = weight / (height * height);
      if (_bmi! < 18.5) {
        _bmiStatus = 'Underweight';
        _bmiColor = Colors.orange;
      } else if (_bmi! < 25) {
        _bmiStatus = 'Normal';
        _bmiColor = Colors.green;
      } else if (_bmi! < 30) {
        _bmiStatus = 'Overweight';
        _bmiColor = Colors.orange;
      } else {
        _bmiStatus = 'Obese';
        _bmiColor = Colors.redAccent;
      }
    } else {
      _bmi = null;
      _bmiStatus = 'No data available';
      _bmiColor = Colors.redAccent;
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    Map<String, dynamic> updatedData = {};
    updatedData[field] = value;
    await DatabaseHelper.instance.updateUserProfile(
      widget.userId,
      birthday: field == 'birthday' ? value : null,
      weight: field == 'weight' ? int.tryParse(value) : null,
      height: field == 'height' ? int.tryParse(value) : null,
      username: field == 'username' ? value : null,
    );
    _loadUserData();
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    birthdayController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _logout() async {
    await SharedPreferencesManager.clearUserId();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // UPDATED PART !! BIRTHDAY WITH CALENDAR
  void _showEditDialog(String field, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        if (field == 'birthday'){
          return AlertDialog(
          title: Text('Edit $field'),
          content: InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900), 
                lastDate: DateTime.now(), 
              );

              if (pickedDate != null) {
                controller.text = DateFormat('dd.MM.yyyy').format(pickedDate);
              }
            },
            child: IgnorePointer(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'New $field'),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateUserData(field, controller.text);
              },
              child: Text('Save'),
            ),
          ],
          );
        }
        else{
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'New $field'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateUserData(field, controller.text);
                if (field == 'weight' || field == 'height') {
                  _calculateBMI();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
        }
      },
    );
  }

  @override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  return Scaffold(
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
                  Text(
                    'My Profile',
                    style: GoogleFonts.dancingScript(
                      textStyle: TextStyle(color: Color(0xFF49688D), fontSize: 50),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showEditDialog('username', usernameController),
                    child: buildEditableField(usernameController, hint: "Username"),
                  ),
                  GestureDetector(
                    onTap: () => _showEditDialog('weight', weightController),
                    child: buildEditableField(weightController, hint: "Weight (kg)"),
                  ),
                  GestureDetector(
                    onTap: () => _showEditDialog('height', heightController),
                    child: buildEditableField(heightController, hint: "Height (cm)"),
                  ),
                  GestureDetector(
                    onTap: () => _showEditDialog('birthday', birthdayController),
                    child: buildEditableField(birthdayController, hint: "Birthday"),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: _bmiColor, width: 2),
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
                        Icon(Icons.balance, color: _bmiColor, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BMI',
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: _bmiColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _bmi != null ? _bmi!.toStringAsFixed(2) : _bmiStatus,
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
                  ),
                  OutlinedButton(
                    onPressed: _logout,
                    child: Text('Logout'),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(Size(250.0, 40.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF49688D)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 231, 240, 252),
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
    bottomNavigationBar: BottomNavBar(userId: widget.userId),
  );
}
  Widget buildEditableField(TextEditingController controller, {String hint = ""}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xFF49688D), width: 2),
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
          Icon(Icons.edit, color: Color(0xFF49688D), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hint,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF49688D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.text,
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










