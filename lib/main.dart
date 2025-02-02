import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Provider_Helper/date_time_notifier.dart';
import 'Screens/splash_screens.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DateTimeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EchoGpt Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Set AppBar color to white
        ),
      ),
      home: SplashScreen(),
    );
  }
}
