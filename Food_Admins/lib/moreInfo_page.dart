import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreInfoPage extends StatelessWidget {
  final String title;
  final String content;

  const MoreInfoPage({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.dancingScript(
            textStyle: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        backgroundColor: Color(0xFFE15D55),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFEFE),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dancingScript(
                    textStyle: TextStyle(color: Color(0xFF49688D), fontSize: 28),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF6394AD).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    content,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildAdditionalInfo(title),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(String title) {
    switch (title) {
      case 'How to Optimize Iron Intake':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Iron-Rich Foods:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF49688D)),
            ),
            SizedBox(height: 10),
            Text(
              '• Red meat, pork, and poultry\n• Seafood\n• Beans\n• Dark leafy greens\n• Dried fruit\n• Iron-fortified cereals',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        );
      case 'Menstrual Wellness':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tips for Menstrual Health:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF49688D)),
            ),
            SizedBox(height: 10),
            Text(
              '• Maintain a balanced diet\n• Exercise regularly\n• Stay hydrated\n• Practice relaxation techniques\n• Track your cycle',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        );
      case 'Stress Management':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Effective Stress Relievers:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF49688D)),
            ),
            SizedBox(height: 10),
            Text(
              '• Meditation and mindfulness\n• Regular physical activity\n• Hobbies and interests\n• Connecting with loved ones\n• Professional counseling',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        );
      case 'Iron-Rich Recipes':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sample Recipes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF49688D)),
            ),
            SizedBox(height: 10),
            Text(
              '• Spinach and Lentil Salad\n• Beef and Broccoli Stir-Fry\n• Chickpea and Quinoa Bowl',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        );
      case 'SDG Alignment':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are the SDGs?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF49688D)),
            ),
            SizedBox(height: 10),
            Text(
              'The Sustainable Development Goals (SDGs) are a set of 17 global goals set by the United Nations to address global challenges.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
