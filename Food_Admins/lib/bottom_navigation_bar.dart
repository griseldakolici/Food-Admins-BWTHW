import 'package:flutter/material.dart';
import 'package:food_admins_test/period_details_page.dart';
import 'user_profile.dart';
import 'dashboard.dart';
import 'insights.dart';

class BottomNavBar extends StatelessWidget {
  final int userId;

  BottomNavBar({required this.userId});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.home, color: Color(0xFF6394AD)),
            onPressed: () {
              _navigateToPage(context, Dashboard(userId: userId));
            },
          ),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.person, color: Color(0xFF6394AD)),
            onPressed: () {
              _navigateToPage(context, Profile2(userId: userId));
            },
          ),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.bar_chart, color: Color(0xFF6394AD)),
            onPressed: () {
              _navigateToPage(context, InsightsPage(userId: userId,));
            },
          ),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.bloodtype_outlined, color: Color(0xFF6394AD)),
            onPressed: () {
              _navigateToPage(context, PeriodDetailsPage(userId: userId));
            },
          ),
        ],
      ),
    );
  }
}

class UnderConstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Under Construction'),
      ),
      body: Center(
        child: Text('This page is under construction.'),
      ),
    );
  }
}
