import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repository/api_services.dart';
import '../Widgets/custom_text_field.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text field controllers
  final emailNameController = TextEditingController();
  final passwordController = TextEditingController();

  // State variable to track checkbox
  bool _rememberMe = false;

  // API service instance
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    _checkRememberMeStatus();
  }

  // Check if "Remember Me" was selected previously
  Future<void> _checkRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool('rememberMe');
    if (rememberMe != null && rememberMe) {
      // Navigate directly to the dashboard screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    }
  }

  Future<void> _handleLogin() async {
    // Assuming login logic goes here and is successful

    // Save the "Remember Me" status if selected
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _rememberMe);

    // Navigate to the dashboard
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DashboardScreen()),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the screen is removed from memory
    emailNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Method to show error alert dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show loading alert dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Logging in...', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Please wait a second.', style: TextStyle(fontSize: 14)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.08,
                ),
                const Text(
                  'Log in',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height * 0.19,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, bottom: height * 0.007),
                      child: const Text(
                        'Email',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Email Field
                CustomTextField(
                  hintText: 'Enter your email',
                  obscure: false,
                  controller: emailNameController,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06,
                          top: height * 0.01,
                          bottom: height * 0.007),
                      child: const Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Password Field
                CustomTextField(
                  hintText: 'Enter your password',
                  obscure: true,
                  controller: passwordController,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      left: width * 0.06,
                    )),
                    Row(
                      children: [
                        // Rounded Checkbox with reduced internal padding
                        Transform.scale(
                          scale: 1.2, // Keep the scale or adjust if necessary
                          child: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              width: 1.2,
                              color: Colors.grey,
                            ),
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: const Color(
                                0xff4979FB), // Blue color when checked
                            visualDensity: const VisualDensity(
                                horizontal: -4.0,
                                vertical: -4.0), // Decrease internal padding
                          ),
                        ),

                        // Text directly after Checkbox without extra space
                        const Text(
                          'Remember me',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),

                InkWell(
                  onTap: () async {
                    String email = emailNameController.text;
                    String password = passwordController.text;

                    // Show loading dialog
                    _showLoadingDialog();

                    // Proceed with login attempt
                    bool isLoggedIn = await _apiServices.login(email, password);

                    // Close the loading dialog
                    Navigator.of(context).pop();

                    if (isLoggedIn) {
                      //remembered me or not
                      _handleLogin();
                      // Clear text fields after successful login
                      emailNameController.clear();
                      passwordController.clear();

                      // Navigate to the dashboard screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    } else {
                      // Show an alert dialog for failed login
                      _showErrorDialog('Login failed. Check your credentials.');
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      color: const Color(0xff4979FB),
                    ),
                    child: const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
