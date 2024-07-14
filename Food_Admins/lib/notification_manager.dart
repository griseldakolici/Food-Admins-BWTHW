import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// List of iron-related tips
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

// Function to get a random iron tip from the list
String getRandomIronTip() {
  final Random random = Random();
  return ironTips[random.nextInt(ironTips.length)];
}

// Setup notifications with Timer to show notifications every minute
// Function to configure and schedule notifications
void setupNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  // Define a notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'iron_tips_channel', // Channel ID
    'Iron Tips', // Channel name
    importance: Importance.high, // Importance level
  );

  // Create the notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Initialize the notification details with androidAllowWhileIdle
  NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id, // Channel ID
      channel.name, // Channel name
      channelDescription: 'Receive iron-related tips every minute',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
    ),
  );

  // Start a periodic timer to show notifications every minute
  Timer.periodic(Duration(minutes: 2), (_) async {
    String tip = getRandomIronTip(); // Get a new random iron tip each time
    flutterLocalNotificationsPlugin.show(
      0, // Notification id
      'Iron Tip', // Notification title
      tip, // Notification body with the new random iron tip
      notificationDetails,
    );
  });
}
