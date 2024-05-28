import 'package:chess/components/piece.dart';
import 'package:chess/functions/king_ckeck.dart';
import 'package:chess/functions/moves/adjacent_king.dart';
import 'package:chess/functions/moves/raw_moves.dart';

bool canMove(
  List<List<ChessPiece?>> board,
  List<int> from,
  List<int> to,
  List<int> kingPosition,
) {
  // move piece from 'from' to 'to'
  // check if this move, clears check on king
  // show the move, else dont :: return true else false

  // store initial board state
  final ChessPiece? fromPiece = board[from[0]][from[1]];
  final ChessPiece? toPiece = board[to[0]][to[1]];

  // Simulate move
  board[to[0]][to[1]] = fromPiece!;
  board[from[0]][from[1]] = null;

  // Update king's position if it's the king that's moving
  List<int> newKingPosition = List<int>.from(kingPosition);

  if (fromPiece.type == ChessPieceType.king) {
    newKingPosition = to;
  }

  final List<List<int>> kingAttackers = isKingInCheck(
    board,
    newKingPosition[0],
    newKingPosition[1],
  );

  // change board state back to initial
  board[from[0]][from[1]] = fromPiece;
  board[to[0]][to[1]] = toPiece;

  return kingAttackers.isEmpty;
}

int getIndexFromMove(List<int> m, List<List<int>> rawMoves) {
  for (int i = 0; i < rawMoves.length; i++) {
    if (rawMoves[i][0] == m[0] && rawMoves[i][1] == m[1]) {
      return i;
    }
  }

  return -1;
}

List<List<int>> getRealMoves(
  List<List<ChessPiece?>> board,
  ChessPiece? selectedPiece,
  List<int> selectedCord,
  bool isWhiteTurn,
  List<int> kingPosition,
) {
  List<List<int>> realMoves = [];
  List<List<int>> rawMoves = getRawMoves(
    board,
    selectedPiece,
    selectedCord,
  );

  if (selectedPiece!.type == ChessPieceType.king) {
    rawMoves.removeWhere(
      (final move) => isKingInAdjacent(board, move, selectedPiece),
    );
  }

  for (final cord in rawMoves) {
    if (canMove(board, selectedCord, cord, kingPosition)) {
      realMoves.add(cord);
    }
  }

  return realMoves;
}
