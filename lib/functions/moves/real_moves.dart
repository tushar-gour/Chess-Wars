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
  board[from[0]][from[1]] = null;
  board[to[0]][to[1]] = fromPiece!;

  final List<List<int>> kingAttackers = isKingInCheck(
    board,
    kingPosition[0],
    kingPosition[1],
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
    // for (int i = 0; i < rawMoves.length; i++) {
    //   if (isKingInAdjacent(board, rawMoves[i], selectedPiece)) {
    //     rawMoves.removeAt(i);
    //   }
    // }

    List<int> indexes = [];

    for (var move in rawMoves) {
      if (isKingInAdjacent(board, move, selectedPiece)) {
        int toRemove = getIndexFromMove(move, rawMoves);
        if (toRemove != -1) indexes.add(toRemove);
      }
    }

    List<List<int>> tempRawMoves = [];

    for (int i = 0; i < rawMoves.length; i++) {
      if (!indexes.contains(i))
        tempRawMoves.add([rawMoves[i][0], rawMoves[i][1]]);
    }

    rawMoves = tempRawMoves;
  }

  for (var cord in rawMoves) {
    if (canMove(
      board,
      selectedCord,
      cord,
      kingPosition,
    )) {
      realMoves.add(cord);
    }
  }

  return realMoves;
}
