import 'package:echogpt_dashboard/Provider_Helper/date_time_notifier.dart';
import 'package:echogpt_dashboard/Screens/details_screen.dart';

import 'package:echogpt_dashboard/Widgets/logout_drawer.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

import '../Repository/api_services.dart';
import '../Models/dashboard_data_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variable to hold the formatted date and time
  String currentDateTime = '';

  // Timer to update the time every minute
  Timer? timer;

  // Api service class instances
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();

    // _apiServices.getTotalPremiumUsers();
    // _apiServices.getTotalPaidAmount();
  }

  // Future<DashboardDataModel?> fetchDashboardData() {
  //   return _apiServices.getDashboardData();
  // }

  Future<void> _refresh() async {
    setState(() {
      // and calling fetchDashboardData to fetch the data again.
      _apiServices.getDashboardData();
      _apiServices.getTotalPremiumUsers();
      _apiServices.getTotalPaidAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Dashboard'),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Opens the drawer
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: LogoutDrawer(),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.01),
                      child: const Text(
                        'All Info',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Current date and time using Consumer
                    Consumer<DateTimeNotifier>(
                      builder: (context, dateTimeNotifier, child) {
                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.01),
                          child: Text(
                            dateTimeNotifier.currentDateTime,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),

                //Card Section using FutureBuilder to fetch API data
                FutureBuilder(
                  future: Future.wait([
                    _apiServices.getDashboardData(),
                    _apiServices.getTotalPaidAmount(),
                    _apiServices.getTotalPremiumUsers(),
                  ]), // Combine all futures
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Single progress indicator
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error: ${snapshot.error}')); // Handle API error
                    } else if (snapshot.hasData) {
                      // snapshot.data will be a List containing results from all APIs
                      final dashboardData = snapshot.data![0]
                          as DashboardDataModel; // First element is DashboardData
                      final totalPaidAmount = snapshot
                          .data![1]; // Second element is TotalPaidAmount
                      final totalPremiumUsers = snapshot
                          .data![2]; // Third element is TotalPremiumUsers

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildRoundedContainer(
                                    titleText: 'Total Users',
                                    countText:
                                        '${dashboardData.data!.totalUser}', // Update from API
                                    width: width * 0.5,
                                    height: height * 0.15,
                                    color: Color(0xffB9E6FE),
                                    borderColor: Color(0xff0086C9)),
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                child: _buildRoundedContainer(
                                    titleText: 'Total Message',
                                    countText:
                                        '${dashboardData.data!.totalChatMessage}', // Update from API
                                    width: width * 0.5,
                                    height: height * 0.15,
                                    color: Color(0xffE1DBFE),
                                    borderColor: Color(0xff533BCB)),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          // Total Paid Amount and Premium User section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildRoundedContainer(
                                    titleText: 'Total Paid Amount',
                                    countText: 'BDT $totalPaidAmount',
                                    width: width * 0.5,
                                    height: height * 0.15,
                                    color: Color(0xffFFDDD3),
                                    borderColor: Color(0xffCC461B)),
                              ),
                              SizedBox(width: width * 0.02),
                              Expanded(
                                child: _buildRoundedContainer(
                                    titleText: 'Total Premium User',
                                    countText: '$totalPremiumUsers',
                                    width: width * 0.5,
                                    height: height * 0.15,
                                    color: Color(0xffD1FADF),
                                    borderColor: Color(0xff027A48)),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No data available.'));
                    }
                  },
                ),

                SizedBox(height: height * 0.02),

                // User Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Users",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(),
                            ));
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4979FB)),
                      ),
                    ),
                  ],
                ),

                // Display Last 5 Users in ListView.builder
                // Display Last 5 Users in ListView.builder
                Expanded(
                  child: FutureBuilder<DashboardDataModel?>(
                    // Retain this FutureBuilder
                    future: _apiServices.getDashboardData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error: ${snapshot.error}')); // Handle API error
                      } else if (snapshot.hasData) {
                        final dashboardData = snapshot.data!;
                        final users =
                            dashboardData.data?.latestFiveuser; // Last 5 users

                        if (users == null || users.isEmpty) {
                          return const Center(
                              child: Text('No user data available.'));
                        }

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.006),
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: Container(
                                  height: height * 0.04,
                                  width: width * 0.09,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    color: Colors.blue,
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    child: Image.network(
                                      user.picture ??
                                          'https://example.com/default-avatar.png', // Default image URL
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons
                                            .error); // Fallback if image fails to load
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(user.username ??
                                    'Unknown'), // Accessing username correctly
                                subtitle: Text(user.email ??
                                    'No email'), // Accessing email correctly
                                trailing: Text(user.package ??
                                    'No package'), // Accessing package correctly
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('No user data available.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedContainer({
    required String titleText,
    required String countText,
    required double width,
    required double height,
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titleText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              countText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
