import 'dart:async';
import 'package:flutter/material.dart';
import 'package:echogpt_dashboard/Utils/date_time_utils.dart';

class DateTimeNotifier extends ChangeNotifier {
  String _currentDateTime = DateTimeUtils.getFormattedDateTime();
  Timer? _timer;

  DateTimeNotifier() {
    _startTimer();
  }

  String get currentDateTime => _currentDateTime;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    _currentDateTime = DateTimeUtils.getFormattedDateTime();
    notifyListeners(); // Notify listeners of the change
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
