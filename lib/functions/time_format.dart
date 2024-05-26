String formattedTime(int seconds) {
  int hours = seconds ~/ 60;
  int minutes = hours ~/ 60;

  // Format the string with leading zeros
  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');

  return '$formattedHours : $formattedMinutes';
}
