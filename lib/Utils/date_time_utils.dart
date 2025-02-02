class DateTimeUtils {
  static String getFormattedDateTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final isPM = hour >= 12; // Determine if it's PM

    // Convert hour to 12-hour format
    final formattedHour =
        hour % 12 == 0 ? 12 : hour % 12; // Convert hour to 12-hour format

    return "${_getMonthName(now.month)} ${now.day}, ${now.year} | $formattedHour:${minute.toString().padLeft(2, '0')} ${isPM ? 'PM' : 'AM'}";
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
