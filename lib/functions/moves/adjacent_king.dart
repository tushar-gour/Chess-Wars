import 'package:chess/components/piece.dart';
import 'package:chess/functions/helpers.dart';

bool isKingInAdjacent(
  List<List<ChessPiece?>> board,
  List<int> tileCord,
  ChessPiece? kingPiece,
) {
  if (kingPiece == null) return false;

  final moves = [
    [-1, 0], // up
    [1, 0], // down
    [0, -1], // left
    [0, 1], // right
    [-1, -1], // up eft
    [-1, 1], // up right
    [1, -1], // down left
    [1, 1], // down right
  ];

  for (var move in moves) {
    int newRow = tileCord[0] + move[0];
    int newCol = tileCord[1] + move[1];

    if (!isInBoard(newRow, newCol)) continue;

    ChessPiece? piece = board[newRow][newCol];

    if (piece != null &&
        piece.isWhite != kingPiece.isWhite &&
        piece.type == ChessPieceType.king) {
      return true;
    }
  }

  return false;
}
