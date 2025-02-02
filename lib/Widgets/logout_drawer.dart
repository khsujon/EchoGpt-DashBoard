import 'package:echogpt_dashboard/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDrawer extends StatelessWidget {
  const LogoutDrawer({super.key});
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the login key
    await prefs.remove('authToken');

    // Check if the "rememberMe" key exists, and only remove it if it exists
    if (prefs.containsKey('rememberMe')) {
      await prefs.remove('rememberMe');
    }

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold), // Text color
                ),
                SizedBox(width: 8),
                Icon(Icons.logout, color: Colors.red),
              ],
            ),

            //logout
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
