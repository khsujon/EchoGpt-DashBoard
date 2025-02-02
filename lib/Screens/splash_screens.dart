import 'dart:async';
import 'package:echogpt_dashboard/Screens/dashboard_screen.dart';
import 'package:echogpt_dashboard/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool('rememberMe');

    if (rememberMe != null && rememberMe) {
      // Timer for 3 seconds and then navigate to LoginPage
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => DashboardScreen()),
        );
      });
    } else {
      // Go to login screen
      // Timer for 3 seconds and then navigate to LoginPage
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF4979FB),
      body: Center(
          child: Text(
        'EG',
        style: TextStyle(
            color: Colors.white, fontSize: 150, fontWeight: FontWeight.w600),
      )),
    );
  }
}
