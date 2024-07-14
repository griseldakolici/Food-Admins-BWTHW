import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wave_clippers.dart';
import 'moreInfo_page.dart';
import 'bottom_navigation_bar.dart';

class InsightsPage extends StatelessWidget {
  final int userId;

  InsightsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEFE), // Setting the background color
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Container with fixed height for the Stack
                Container(
                  height: 60, // Reduced height for the top wave container
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
                    ],
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 10, 0), // Adjusted padding
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Insights',
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          color: Color(0xFF49688D),
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                // Grid of images
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: GridView.count(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 15, // Horizontal spacing between squares
                      mainAxisSpacing: 15, // Vertical spacing between squares
                      childAspectRatio: 1.35, // Aspect ratio for smaller squares
                      children: [
                        // First square
                        _buildImageCard(
                          context,
                          imagePath: 'lib/images/insights_img1.png',
                          title: 'How to Optimize Iron Intake',
                        ),
                        // Second square
                        _buildImageCard(
                          context,
                          imagePath: 'lib/images/insights_img2.png',
                          title: 'Menstrual Wellness',
                        ),
                        // Third square
                        _buildImageCard(
                          context,
                          imagePath: 'lib/images/insights_img3.png',
                          title: 'Stress Management',
                        ),
                        // Fourth square
                        _buildImageCard(
                          context,
                          imagePath: 'lib/images/insights_img4.png',
                          title: 'Iron-Rich Recipes',
                        ),
                        // Fifth square
                        _buildImageCard(
                          context,
                          imagePath: 'lib/images/insights_img5.png',
                          title: 'SDG Alignment',
                        ),
                        // Sixth square
                        _buildImageCard(
                          context,
                          imagePath: 'lib/images/insights_img6.png',
                          title: 'Others',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(userId: userId), // Use the BottomNavBar
    );
  }

  Widget _buildImageCard(
    BuildContext context, {
    required String imagePath,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoreInfoPage(
              title: title,
              content: pageContents[title] ?? 'No content available.',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF6394AD),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
            SizedBox(height: 5), // Space between image and text
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define your content here
final Map<String, String> pageContents = {
  'How to Optimize Iron Intake': 'Iron is an essential mineral that plays a crucial role in transporting oxygen in the blood. To optimize iron intake, include both heme iron (found in animal products) and non-heme iron (found in plant-based foods) in your diet. Combining these with vitamin C-rich foods can enhance absorption. Avoid consuming calcium-rich foods or beverages and caffeine around the time you eat iron-rich meals, as they can hinder absorption.',
  'Menstrual Wellness': 'Menstrual wellness involves maintaining a healthy menstrual cycle and managing symptoms such as cramps, bloating, and mood swings. Regular physical activity, a balanced diet, and stress management techniques can contribute to menstrual health. It\'s also important to track your cycle to identify any irregularities and consult with a healthcare provider if needed.',
  'Stress Management': 'Managing stress is vital for overall health. Techniques such as deep breathing exercises, meditation, physical activity, and maintaining a healthy work-life balance can help reduce stress levels. Finding hobbies and activities that you enjoy, staying connected with friends and family, and seeking professional help when necessary are also important components of effective stress management.',
  'Iron-Rich Recipes': 'Incorporating iron-rich recipes into your diet can help prevent iron deficiency anemia. Examples include spinach and lentil salad, beef and broccoli stir-fry, and chickpea and quinoa bowls. These recipes not only provide a good source of iron but also include other essential nutrients for overall health.',
  'SDG Alignment': 'The Sustainable Development Goals (SDGs) are a set of 17 global goals set by the United Nations General Assembly in 2015. They aim to address global challenges such as poverty, inequality, climate change, and health. Aligning with SDGs involves adopting practices and policies that contribute to achieving these goals.',
  'Others': 'This section includes various other topics and tips related to health and wellness. Stay tuned for more updates and valuable insights.'
};
