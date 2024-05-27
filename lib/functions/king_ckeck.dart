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

  final direction = kingPiece.isWhite ? -1 : 1;

  // Check if King is being attacked by:
  // PAWN (Diagonally)
  final pawnAttacks = [
    [row + direction, col - 1],
    [row + direction, col + 1],
  ];

  for (var attack in pawnAttacks) {
    if (isInBoard(attack[0], attack[1])) {
      final attacker = board[attack[0]][attack[1]];
      if (attacker != null &&
          attacker.isWhite != kingPiece.isWhite &&
          attacker.type == ChessPieceType.pawn) {
        attacking_pieces.add(attack);
      }
    }
  }

  // ROOK and QUEEN (up, down, left, right)
  final rookMoves = [
    [-1, 0], // up
    [1, 0], // down
    [0, -1], // left
    [0, 1], // right
  ];

  for (var move in rookMoves) {
    int i = 1;
    while (true) {
      int newRow = row + i * move[0];
      int newCol = col + i * move[1];

      if (!isInBoard(newRow, newCol)) break;

      final attacker = board[newRow][newCol];
      if (attacker != null) {
        if ((attacker.type != ChessPieceType.rook &&
            attacker.type != ChessPieceType.queen)) continue;

        if (attacker.isWhite != kingPiece.isWhite) {
          attacking_pieces.add([newRow, newCol]);
          break;
        } else {
          break; // blocked by another piece
        }
      }

      i++;
    }
  }

  // KNIGHT (L-shaped moves)
  final knightMoves = [
    [-2, -1],
    [-2, 1],
    [-1, -2],
    [-1, 2],
    [1, -2],
    [1, 2],
    [2, -1],
    [2, 1],
  ];

  for (var move in knightMoves) {
    int newRow = row + move[0];
    int newCol = col + move[1];

    if (isInBoard(newRow, newCol)) {
      final attacker = board[newRow][newCol];
      if (attacker != null &&
          attacker.isWhite != kingPiece.isWhite &&
          attacker.type == ChessPieceType.knight) {
        attacking_pieces.add([newRow, newCol]);
      }
    }
  }

  // BISHOP and QUEEN (diagonally)
  final bishopMoves = [
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1],
  ];

  for (var move in bishopMoves) {
    int i = 1;
    while (true) {
      int newRow = row + i * move[0];
      int newCol = col + i * move[1];

      if (!isInBoard(newRow, newCol)) break;

      final attacker = board[newRow][newCol];
      if (attacker != null) {
        if ((attacker.type != ChessPieceType.bishop &&
            attacker.type != ChessPieceType.queen)) continue;

        if (attacker.isWhite != kingPiece.isWhite) {
          attacking_pieces.add([newRow, newCol]);
          break;
        } else {
          break; // blocked by another piece
        }
      }

      i++;
    }
  }

  return attacking_pieces;
}
