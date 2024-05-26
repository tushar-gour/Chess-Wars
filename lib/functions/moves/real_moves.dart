import 'package:chess/components/piece.dart';
import 'package:chess/functions/king_ckeck.dart';
import 'package:chess/functions/moves/raw_moves.dart';

bool canMove(
  List<List<ChessPiece?>> board,
  List<int> from,
  List<int> to,
  bool isWhite,
  ChessPiece? selectedPiece,
  List<int> kingPosition,
) {
  // move piece from 'from' to 'to'
  // check if this move, clears check on king
  // show the move, else dont :: return true else false
  final ChessPiece? fromPiece = board[from[0]][from[1]];
  final ChessPiece? toPiece = board[to[0]][to[1]];

  board[from[0]][from[1]] = null;
  board[to[0]][to[1]] = selectedPiece;

  final List<List<int>> kingAttackers = isKingInCheck(
    board,
    kingPosition[0],
    kingPosition[1],
  );

  board[from[0]][from[1]] = fromPiece;
  board[to[0]][to[1]] = toPiece;

  return kingAttackers.isEmpty;
}

List<List<int>> getRealMoves(
  List<List<ChessPiece?>> board,
  ChessPiece? selectedPiece,
  List<int> selectedCord,
  bool isWhiteTurn,
  List<int> kingPosition,
) {
  List<List<int>> realMoves = [];

  final List<List<int>> rawMoves = getRawMoves(
    board,
    selectedPiece,
    selectedCord,
  );

  for (var cord in rawMoves) {
    if (canMove(
      board,
      selectedCord,
      cord,
      selectedPiece!.isWhite,
      selectedPiece,
      kingPosition,
    )) {
      realMoves.add(cord);
    }
  }

  return realMoves;
}
