List<int> getTileCoordinates(int index) {
  int x = index ~/ 8;
  int y = index % 8;

  return [x, y];
}

bool isDarkTile(int index) {
  List<int> xy = getTileCoordinates(index);
  return (xy[0] + xy[1]) % 2 == 0;
}

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

String formattedTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;

  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

  return '$formattedMinutes : $formattedSeconds';
}
