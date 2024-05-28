import 'package:chess/components/piece.dart';

bool isKingsRemaining(List<List<ChessPiece?>> board) {
  List<ChessPiece> remainings = [];

  for (var row in board) {
    for (var tile in row) {
      if (tile != null) {
        remainings.add(tile);
      }
    }
  }

  return remainings.length == 2 &&
      remainings[0].type == ChessPieceType.king &&
      remainings[1].type == ChessPieceType.king;
}
