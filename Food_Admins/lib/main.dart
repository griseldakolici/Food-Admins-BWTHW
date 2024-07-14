import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'shared_preferences.dart';
import 'providers/data_provider.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final List<String> ironTips = [
  "🍎 An apple a day keeps anemia away! Enjoy a crisp apple for a boost of iron.",
  "🥬 Leafy greens like spinach and kale are your iron-rich buddies! Have a salad today.",
  "💧 Stay hydrated! Drink plenty of water to help your body absorb iron.",
  "🥩 Beef up your iron levels with lean red meat. How about a delicious steak for dinner?",
  "🥜 Nuts and seeds are tiny powerhouses of iron! Snack on almonds or pumpkin seeds.",
  "🍊 Add a squeeze of lemon to your meals. Vitamin C helps your body absorb iron better!",
  "🍳 Start your day sunny-side up! Eggs are packed with iron and protein.",
  "🌿 Brew a cup of herbal tea like nettle or dandelion. It's a natural iron booster!",
  "🥣 Oatmeal makes a hearty breakfast choice. Top it with fruits and nuts for extra iron.",
  "🍌 Bananas are not just for monkeys! They're rich in iron and potassium. Peel one for a snack."
];

String getRandomIronTip() {
  final Random random = Random();
  return ironTips[random.nextInt(ironTips.length)];
}

void setupNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'iron_tips_channel', 
    'Iron Tips', 
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id, 
      channel.name, 
      channelDescription: 'Receive iron-related tips every two minutes',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
    ),
  );

  Timer.periodic(Duration(minutes: 2), (_) async {
    String tip = getRandomIronTip(); 
    flutterLocalNotificationsPlugin.show(
      0, 
      'Iron Tip', 
      tip, 
      notificationDetails,
    );
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.init();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher'); // Use the default launcher icon

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  setupNotifications(flutterLocalNotificationsPlugin);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), 
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}



