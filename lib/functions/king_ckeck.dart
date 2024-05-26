import 'package:chess/components/piece.dart';
import 'package:chess/functions/helpers.dart';

List<List<int>> isKingInCheck(
  List<List<ChessPiece?>> board,
  int row,
  int col,
) {
  List<List<int>> attacking_pieces = [];
  final ChessPiece? kingPiece = board[row][col];

  if (kingPiece == null) return attacking_pieces;

  // check if the king is in sight of any piece on board
  // i.e., check for every piece in chess if their next move is killing king or not
  // i.e., check for every piece raw movement and check if their next valid move has tile of king

  final direction = kingPiece.isWhite ? -1 : 1;

  // check if King is being attacked by:

  // PAWN ( Diagonally )
  if (isInBoard(row + direction, col - 1) &&
      board[row + direction][col - 1] != null &&
      board[row + direction][col - 1]!.isWhite != kingPiece.isWhite) {
    attacking_pieces.add([row + direction, col - 1]);
  }

  if (isInBoard(row + direction, col + 1) &&
      board[row + direction][col + 1] != null &&
      board[row + direction][col + 1]!.isWhite != kingPiece.isWhite) {
    attacking_pieces.add([row + direction, col + 1]);
  }

  return attacking_pieces;
}
