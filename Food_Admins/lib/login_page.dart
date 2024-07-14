import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wave_clippers.dart';
import 'database_helper.dart';
import 'registration_page.dart';
import 'initial_setup.dart'; 
import 'shared_preferences.dart';
import 'user_profile.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

Future<int?> authenticateUser(String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    final hashedPassword = DatabaseHelper.instance.hashPassword(password);

    try {
      var result = await db.query(
        'users',
        columns: ['id', 'is_setup_complete'],
        where: 'username = ? AND password = ?',
        whereArgs: [username, hashedPassword],
      );

      if (result.isNotEmpty) {
          return result.first['id'] as int;  // Return user ID if authenticated
      }
    } catch (e) {
      print("Database query failed: $e");  // Log any exceptions thrown by the query
      return null;
    }
    return null;  // Return null if user not found or password does not match
}

void attemptLogin() async {
  int? userId = await authenticateUser(
    usernameController.text.trim(),
    passwordController.text.trim(),
  );

  if (userId != null) {
    await SharedPreferencesManager.setUserId(userId);  // Store user ID in SharedPreferences
    bool setupComplete = await DatabaseHelper.instance.isSetupComplete(userId);

    if (!setupComplete) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => InitialSetupPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Profile2(userId: userId)),
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Login Failed"),
        content: Text("Invalid username or password."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
                Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFE),
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
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'lib/images/login_page_img1.png', 
                      width: 170,
                      height: 170,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome',
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          color: Color(0xFF49688D),
                          fontSize: 43,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF49688D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF49688D)),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF49688D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF49688D)),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: attemptLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEED5C7),
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Log In'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
  );
                        // Navigation to Forgot Password Page
                      },
                      child: Text('Forgot Password?'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegistrationPage()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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


