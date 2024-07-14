import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wave_clippers.dart';
import 'database_helper.dart';
import 'login_page.dart'; 
import 'shared_preferences.dart'; 

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
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
                  color: const Color(0xFFEED5C7),
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
                  color: const Color(0xFF6394AD),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: Text(
                        'Register',
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                            color: Color(0xFF49688D),
                            fontSize: 43,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildTextField('Username', usernameController),
                    const SizedBox(height: 10),
                    buildTextField('Email', emailController),
                    const SizedBox(height: 10),
                    buildTextField('Password', passwordController, isPassword: true),
                    const SizedBox(height: 10),
                    buildTextField('Confirm Password', confirmPasswordController, isPassword: true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerUser,
                      child: const Text('Register'),
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

  void registerUser() async {
  if (passwordController.text != confirmPasswordController.text) {
    showAlertDialog(context, "Error", "Passwords do not match.");
    return;
  }

  final dbHelper = DatabaseHelper.instance;
  final hashedPassword = dbHelper.hashPassword(passwordController.text);
  final int result = await dbHelper.insertUser({
    'email': emailController.text.trim(),
    'username': usernameController.text.trim(),
    'password': hashedPassword,
  });

  if (result > 0) {
    await SharedPreferencesManager.setUserId(result);
    showAlertDialog(context, "Success", "Registration successful!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to main app page or initial setup
    );
  } else if (result == -1) {
    showAlertDialog(context, "Error", "Could not register. Username or email might already be in use.");
  } else {
    showAlertDialog(context, "Error", "Registration failed. Please try again.");
  }
}

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF49688D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF49688D)),
          ),
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
