import 'dart:convert';
import 'dart:developer';
import 'package:echogpt_dashboard/Models/all_user_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/dashboard_data_model.dart';

class ApiServices {
  static String _token = ""; // Token storage

  // Login method that takes email and password as parameters
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://gpt.mdsami.me/v1/admin/login'),
      body: {
        "email": email,
        "password": password,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true && responseData['data'] != null) {
        // Store the token globally
        _token = responseData['data']['token'];
        print("Token stored: $_token");

        // Save the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', _token); // Save token persistently

        return true; // Login successful
      } else {
        print("Login failed: ${responseData['message']}");
      }
    }

    return false; // Login failed
  }

  // Method to get the token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken') ?? ""; // Retrieve token if it exists
    return _token;
  }

  // void testLogin(String email, String password) async {
  //   bool isLoggedIn = await login(email, password);
  //   if (isLoggedIn) {
  //     print("Login successful! Token: ${getToken()}");
  //   } else {
  //     print("Login failed. Check credentials.");
  //   }
  // }

  //Dashboard api services
  Future<DashboardDataModel?> getDashboardData() async {
    await getToken();
    final response = await http.get(
      Uri.parse('https://gpt.mdsami.me/v1/admin/dashboard'),
      headers: {
        'Authorization': 'Bearer $_token', // Pass the Bearer token
      },
    );

    // print('Dashboard Response status: ${response.statusCode}');
    // print('Dashboard Response body: ${response.body}');

    // Check if the request was successful
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return DashboardDataModel.fromJson(responseData);
    } else {
      print('Failed to load dashboard data: ${response.statusCode}');
      return null;
    }
  }

  //AllUserList Api services
  Future<AllUserListModel?> getAllUserList() async {
    await getToken();
    final response = await http.get(
      Uri.parse(
          'https://gpt.mdsami.me/v1/admin/users'), // Replace with your actual endpoint
      headers: {
        'Authorization': 'Bearer $_token', // Pass the Bearer token
      },
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return AllUserListModel.fromJson(responseData);
    } else {
      print('Failed to load user list: ${response.statusCode}');
      return null;
    }
  }

  // Count total premium users
  Future<int> getTotalPremiumUsers() async {
    final allUsers = await getAllUserList();
    if (allUsers == null || allUsers.data == null) {
      return 0; // Return 0 if there's no user data
    }

    int totalPremiumUsers = 0;

    // Iterate through the user list and count premium users
    for (var user in allUsers.data!) {
      if (user.package != "Free") {
        totalPremiumUsers++;
      }
    }
    //log('Total Premeum user: $totalPremiumUsers');
    return totalPremiumUsers;
  }

  // Calculate total paid amount
  Future<int> getTotalPaidAmount() async {
    final allUsers = await getAllUserList();
    if (allUsers == null || allUsers.data == null) {
      return 0; // Return 0 if there's no user data
    }

    int totalAmount = 0;

    // Iterate through the user list and calculate the total paid amount based on package
    for (var user in allUsers.data!) {
      switch (user.package) {
        case 'Annual':
          totalAmount += 5999;
          break;
        case 'Semi-Annual':
          totalAmount += 3499;
          break;
        case 'Quarterly':
          totalAmount += 1999;
          break;
        case 'Monthly':
          totalAmount += 999;
          break;
        default:
          break;
      }
    }
    //log('Total amount: $totalAmount');

    return totalAmount;
  }
}
