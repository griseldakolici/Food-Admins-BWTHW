import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database_helper.dart';
import 'user_profile.dart';
import '../wave_clippers.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String currentStep = 'verification'; // Can be 'verification' or 'new_password'
  int? userId;

  void _verifyUser() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();

    // Check if the username and email match in the database
    Map<String, dynamic>? userDetails = await DatabaseHelper.instance.getUserByUsernameAndEmail(username, email);
    if (userDetails != null) {
      setState(() {
        userId = userDetails['id'];
        currentStep = 'new_password';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username or Email is incorrect')),
      );
    }
  }

  void _resetPassword() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (userId != null) {
      // Update the password in the database
      await DatabaseHelper.instance.updatePassword(userId!, newPassword);

      // Redirect to the Profile2 page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile2(userId: userId!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is null')),
      );
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot Password',
                      style: GoogleFonts.dancingScript(
                        fontSize: 32,
                        color: Color(0xFF49688D),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (currentStep == 'verification') ...[
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Enter your username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Color(0xFF6394AD)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Color(0xFF6394AD)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _verifyUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6394AD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Verify'),
                      ),
                    ] else if (currentStep == 'new_password') ...[
                      TextField(
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Enter new password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Color(0xFF6394AD)),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm new password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Color(0xFF6394AD)),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6394AD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Reset Password'),
                      ),
                    ],
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




