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
