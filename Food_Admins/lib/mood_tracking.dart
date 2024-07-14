import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'wave_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mood_history.dart';

class MoodTrackingPage extends StatefulWidget {
  final int userId;

  MoodTrackingPage({required this.userId});

  @override
  _MoodTrackingPageState createState() => _MoodTrackingPageState();
}

class _MoodTrackingPageState extends State<MoodTrackingPage> {
  final TextEditingController notesController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final List<String> moodNames = [
    'Happy',
    'Sad',
    'Anxious',
    'Excited',
    'Tired',
    'Calm'
  ];
  Map<String, bool> selectedMoods = {};

  @override
  void initState() {
    super.initState();
    for (var mood in moodNames) {
      selectedMoods[mood] = false;
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
                  color: const Color(0xFFE15D55),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        BackButton(),
                        Expanded(
                          child: Text(
                            'Mood',
                            style: GoogleFonts.dancingScript(
                              fontSize: 32,
                              color: Color(0xFF49688D),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Anemia affects your mood and well-being by causing fatigue and dizziness, leading to sadness and irritability. Tracking your mood helps manage these impacts and improve overall health.',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: moodNames.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Color(0xFF6394AD), width: 1.5),
                            ),
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                              title: Text(moodNames[index], style: TextStyle(fontSize: 16)),
                              value: selectedMoods[moodNames[index]],
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedMoods[moodNames[index]] = value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: 'Enter additional notes (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select Date:"),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: _pickDate,
                          child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveMood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6394AD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text('Save Mood'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodHistoryPage(userId: widget.userId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF49688D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: Text('View Mood History'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveMood() async {
    List<String> selectedMoodList = selectedMoods.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedMoodList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one mood')),
      );
      return;
    }

    String moods = selectedMoodList.join(', ');
    String notes = notesController.text.trim();
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);

    await DatabaseHelper.instance.saveMoodData(widget.userId, date, moods, notes: notes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood saved successfully')),
    );

    // Clear the fields
    setState(() {
      notesController.clear();
      selectedMoods.updateAll((key, value) => false);
    });
  }
}

