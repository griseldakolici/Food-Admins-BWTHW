class Mood {
  final String date;
  final String mood;
  final String? notes;

  Mood({
    required this.date,
    required this.mood,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'date': date,
        'mood': mood,
        'notes': notes,
      };

  factory Mood.fromMap(Map<String, dynamic> map) => Mood(
        date: map['date'],
        mood: map['mood'],
        notes: map['notes'],
      );
}

