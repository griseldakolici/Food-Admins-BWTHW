import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/mood.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _databaseVersion = 3; // Increment this whenever the schema changes

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        birthday TEXT,
        weight INTEGER,
        height INTEGER,
        is_setup_complete INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE period_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE fatigue_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        fatigue INTEGER NOT NULL
      )
    ''');
    await db.execute('''
     CREATE TABLE mood_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        mood TEXT NOT NULL,
        notes TEXT
      )
    ''');
    print('Database and tables created successfully');
  }

  Future<int> insertUser(Map<String, dynamic> rowData) async {
    final db = await instance.database;
    try {
      return await db.insert('users', rowData);
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        print('Unique constraint violation: $e');
        return -1;
      }
      print('Error inserting user: $e');
      return -2;
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE fatigue_data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          fatigue INTEGER NOT NULL
        )
      ''');
      print('fatigue_data table created successfully');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE mood_data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          mood TEXT NOT NULL,
          notes TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id)
        )
      ''');
      print('mood_data table created successfully');
    }
  }

 Future<int> saveMoodData(int userId, String date, String mood, {String? notes}) async {
    final db = await instance.database;
    final data = {
      'user_id': userId,
      'date': date,
      'mood': mood,
      'notes': notes,
    };
    try {
      return await db.insert('mood_data', data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error saving mood data: $e');
      return -1;
    }
  }

  Future<List<Mood>> getMoodDataForDateRange(int userId, String startDate, String endDate) async {
    final db = await instance.database;
    try {
      final results = await db.query(
        'mood_data',
        columns: ['date', 'mood', 'notes'],
        where: 'user_id = ? AND date BETWEEN ? AND ?',
        whereArgs: [userId, startDate, endDate],
        orderBy: 'date ASC',
      );
      return results.map((e) => Mood.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching mood data: $e');
      return [];
    }
  }
  
  Future<int> savePeriodData(int userId, String startDate, String? endDate) async {
    final db = await instance.database;
    final data = {
      'user_id': userId,
      'start_date': startDate,
      'end_date': endDate
    };
    try {
      return await db.insert('period_data', data);
    } catch (e) {
      print('Error saving period data: $e');
      return -1;
    }
  }


  Future<int> updatePeriodEndDate(int userId, int periodId, String endDate) async {
    final db = await instance.database;
    try {
      return await db.update(
        'period_data',
        {'end_date': endDate},
        where: 'user_id = ? AND id = ?',
        whereArgs: [userId, periodId],
      );
    } catch (e) {
      print('Error updating period end date: $e');
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getLastPeriodEntry(int userId) async {
    final db = await instance.database;
    try {
      final results = await db.query(
        'period_data',
        columns: ['id', 'start_date', 'end_date'],
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'start_date DESC',
        limit: 1,
      );
      if (results.isNotEmpty) {
        return results.first;
      }
    } catch (e) {
      print('Error fetching last period entry: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPeriodDetails(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'period_data',
      columns: ['start_date', 'end_date'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_date DESC',
      limit: 2,
    );

    if (results.isEmpty) return null;

    var lastPeriod = results.first;
    DateTime lastStartDate = DateTime.parse(lastPeriod['start_date']);
    DateTime? lastEndDate = lastPeriod['end_date'] != null ? DateTime.parse(lastPeriod['end_date']) : null;
    int periodDuration = lastEndDate != null ? lastEndDate.difference(lastStartDate).inDays : DateTime.now().difference(lastStartDate).inDays;

    int? cycleLength;
    if (results.length > 1) {
      var previousPeriod = results[1];
      DateTime previousStartDate = DateTime.parse(previousPeriod['start_date']);
      cycleLength = lastStartDate.difference(previousStartDate).inDays;
    }

    return {
      'lastStartDate': lastStartDate,
      'lastEndDate': lastEndDate,
      'lastPeriodDuration': periodDuration,
      'lastCycleLength': cycleLength,
      'cycleNormality': cycleLength != null && (cycleLength >= 21 && cycleLength <= 35) ? 'Normal' : 'Atypical'
    };
  }

Future<Map<String, dynamic>?> getUserByUsernameAndEmail(String username, String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND email = ?',
      whereArgs: [username, email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

   Future<int> updatePassword(int userId, String newPassword) async {
    final db = await instance.database;
    final hashedPassword = hashPassword(newPassword); // Assuming you have a hashPassword function
    return await db.update(
      'users',
      {'password': hashedPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateUserProfile(int id, {String? birthday, int? weight, int? height, String? username}) async {
  final db = await instance.database;

  Map<String, dynamic> updateData = {};
  if (birthday != null) updateData['birthday'] = birthday;
  if (weight != null) updateData['weight'] = weight;
  if (height != null) updateData['height'] = height;
  if (username != null) updateData['username'] = username;

  if (updateData.isEmpty) {
    // Nothing to update
    return 0;
  }

int calculateAge(DateTime birthDate) {
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

  return await db.update(
    'users',
    updateData,
    where: 'id = ?',
    whereArgs: [id],
  );
}

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> completeUserProfile(int id, String birthday, int weight, int height) async {
    final db = await this.database;
    return await db.update(
      'users',
      {
        'birthday': birthday,
        'weight': weight,
        'height': height,
        'is_setup_complete': 1
      },
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<bool> isSetupComplete(int userId) async {
    final db = await this.database;
    var res = await db.query(
      'users',
      columns: ['is_setup_complete'],
      where: 'id = ?',
      whereArgs: [userId]
    );
    if (res.isNotEmpty) {
      return res.first['is_setup_complete'] == 1;
    }
    return false;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Map<String, dynamic>?> getUserDetails(int userId) async {
  final db = await this.database;
  try {
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      columns: ['username', 'weight', 'height', 'birthday'],
      where: 'id = ?',
      whereArgs: [userId]
    );
    if (results.isNotEmpty) {
      return results.first;
    }
  } catch (e) {
    print('Error fetching user details: $e');
  }
  return null;
}

  Future<int> saveFatigueData(String date, bool fatigue) async {
    final db = await instance.database;
    final data = {
      'date': date,
      'fatigue': fatigue ? 1 : 0,
    };
    try {
      return await db.insert('fatigue_data', data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error saving fatigue data: $e');
      return -1;
    }
  }

Future<List<Map<String, dynamic>>> getPeriodDataForDateRange(int userId, String startDate, String endDate) async {
  final db = await instance.database;
  try {
    final results = await db.query(
      'period_data',
      columns: ['start_date', 'end_date'],
      where: 'user_id = ? AND (start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ?)',
      whereArgs: [userId, startDate, endDate, startDate, endDate],
    );
    return results;
  } catch (e) {
    print('Error fetching period data for date range: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> getFatigueDataForDateRange(String startDate, String endDate) async {
  final db = await instance.database;
  try {
    final results = await db.query(
      'fatigue_data',
      columns: ['date', 'fatigue'],
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );
    return results;
  } catch (e) {
    print('Error fetching fatigue data for date range: $e');
    return [];
  }
}

  Future<List<Map<String, dynamic>>> getFatigueData() async {
    final db = await instance.database;
    try {
      final results = await db.query(
        'fatigue_data',
        columns: ['date', 'fatigue'],
        orderBy: 'date ASC',
      );
      return results;
    } catch (e) {
      print('Error fetching fatigue data: $e');
      return [];
    }
  }
}









