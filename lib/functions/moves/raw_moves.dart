import 'package:chess/components/piece.dart';
import 'package:chess/functions/helpers.dart';

List<List<int>> getRawMoves(
  List<List<ChessPiece?>> board,
  ChessPiece? selectedPiece,
  List<int> selectedCord,
) {
  List<List<int>> rawMoves = [];

  final ChessPiece? piece = selectedPiece;
  if (piece == null) return rawMoves;

  final int row = selectedCord[0];
  final int col = selectedCord[1];
  final int direction = piece.isWhite ? -1 : 1;

  switch (piece.type) {
    case ChessPieceType.pawn:
      // forward move if tile is empty
      if (isInBoard(row + direction, col) &&
          board[row + direction][col] == null) {
        rawMoves.add([row + direction, col]);
      }

      // 2 step forward movement (only 1 time)
      if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
        if (isInBoard(row + 2 * direction, col) &&
            board[row + 2 * direction][col] == null &&
            board[row + direction][col] == null) {
          rawMoves.add([row + 2 * direction, col]);
        }
      }

      // diagonal attacks
      if (isInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.isWhite != piece.isWhite) {
        rawMoves.add([row + direction, col - 1]);
      }

      if (isInBoard(row + direction, col + 1) &&
          board[row + direction][col + 1] != null &&
          board[row + direction][col + 1]!.isWhite != piece.isWhite) {
        rawMoves.add([row + direction, col + 1]);
      }
      break;
    case ChessPieceType.rook:
      // horizontal and vertical directions
      final rookMoves = [
        [-1, 0], // up
        [1, 0], // down
        [0, -1], // left
        [0, 1] // right
      ];

      for (var move in rookMoves) {
        int i = 1;
        while (true) {
          int newRow = row + i * move[0];
          int newCol = col + i * move[1];

          if (!isInBoard(newRow, newCol)) break;

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              rawMoves.add([newRow, newCol]); // can kill
            }
            break; // blocked
          }

          rawMoves.add([newRow, newCol]);
          i++;
        }
      }

      break;
    case ChessPieceType.knight:
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
        int newRow = row + move[0] * direction;
        int newCol = col + move[1] * direction;

        if (!isInBoard(newRow, newCol)) continue;

        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            rawMoves.add([newRow, newCol]); // can kill
          }
          continue; // blocked
        }
        rawMoves.add([newRow, newCol]);
      }

      break;
    case ChessPieceType.bishop:
      // diagonal directions
      final bishopMoves = [
        [-1, -1], // up eft
        [-1, 1], // up right
        [1, -1], // down left
        [1, 1], // down right
      ];

      for (var move in bishopMoves) {
        int i = 1;
        while (true) {
          int newRow = row + i * move[0];
          int newCol = col + i * move[1];

          if (!isInBoard(newRow, newCol)) break;

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              rawMoves.add([newRow, newCol]); // can kill
            }
            break; // blocked
          }

          rawMoves.add([newRow, newCol]);
          i++;
        }
      }

      break;
    case ChessPieceType.queen:
      final queenMoves = [
        [-1, 0], // up
        [1, 0], // down
        [0, -1], // left
        [0, 1], // right
        [-1, -1], // up eft
        [-1, 1], // up right
        [1, -1], // down left
        [1, 1], // down right
      ];

      for (var move in queenMoves) {
        int i = 1;
        while (true) {
          int newRow = row + i * move[0];
          int newCol = col + i * move[1];

          if (!isInBoard(newRow, newCol)) break;

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              rawMoves.add([newRow, newCol]); // can kill
            }
            break; // blocked
          }

          rawMoves.add([newRow, newCol]);
          i++;
        }
      }

      break;
    case ChessPieceType.king:
      final kingMoves = [
        [-1, 0], // up
        [1, 0], // down
        [0, -1], // left
        [0, 1], // right
        [-1, -1], // up eft
        [-1, 1], // up right
        [1, -1], // down left
        [1, 1], // down right
      ];

      for (var move in kingMoves) {
        int newRow = row + move[0];
        int newCol = col + move[1];

        if (!isInBoard(newRow, newCol)) continue;

        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            rawMoves.add([newRow, newCol]); // can kill
          }
          continue; // blocked
        }

        rawMoves.add([newRow, newCol]);
      }
      break;
  }
  return rawMoves;
}
