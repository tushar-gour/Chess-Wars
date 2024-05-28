import 'package:chess/components/piece.dart';
import 'package:chess/functions/moves/real_moves.dart';

bool isCheckmate(
    List<List<ChessPiece?>> board, bool isWhiteTurn, List<int> kingPosition) {
  // List to keep track of all valid moves available for the current player
  List<List<int>> validMovesAvailable = [];

  /* ---- LOGIC ----
    1. Loop through every tile on the board
    2. Identify all pieces belonging to the current player
    3. For each piece, get all valid moves using getRealMoves
    4. If any valid move is available, it's not checkmate
  */

  // Helper function to add all moves of a piece to the total valid moves
  void addToTotalMoves(List<List<int>> pieceMoves) {
    for (final move in pieceMoves) {
      validMovesAvailable.add(move);
    }
  }

  // Iterate through the entire board
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      final ChessPiece? piece = board[i][j];
      if (piece != null && piece.isWhite == isWhiteTurn) {
        // Get all valid moves for the current piece
        List<List<int>> pieceMoves = getRealMoves(
          board,
          piece,
          [i, j],
          isWhiteTurn,
          kingPosition,
        );
        // Add these moves to the total valid moves available
        if (pieceMoves.isNotEmpty) addToTotalMoves(pieceMoves);
      }
    }
  }

  // If there are no valid moves available, it is checkmate
  return validMovesAvailable.isEmpty;
}
