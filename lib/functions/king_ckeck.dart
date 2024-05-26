import 'package:chess/components/piece.dart';
import 'package:chess/functions/helpers.dart';

bool isAlreadyInAttacker(List<List<int>> attackers, int row, int col) {
  for (var pair in attackers) {
    if (pair[0] == row && pair[1] == col) return true;
  }

  return false;
}

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
      board[row + direction][col - 1]!.isWhite != kingPiece.isWhite &&
      board[row + direction][col - 1]!.type == ChessPieceType.pawn) {
    attacking_pieces.add([row + direction, col - 1]);
  }

  if (isInBoard(row + direction, col + 1) &&
      board[row + direction][col + 1] != null &&
      board[row + direction][col + 1]!.isWhite != kingPiece.isWhite &&
      board[row + direction][col + 1]!.type == ChessPieceType.pawn) {
    attacking_pieces.add([row + direction, col + 1]);
  }

  // ROOK ( up down left right )
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
        if (!isAlreadyInAttacker(attacking_pieces, newRow, newCol) &&
            board[newRow][newCol]!.isWhite != kingPiece.isWhite &&
            board[newRow][newCol]!.type == ChessPieceType.rook) {
          attacking_pieces.add([newRow, newCol]); // can kill
        }
        break; // blocked
      }

      i++;
    }
  }

  // KNIGHT ( 2 and 1 )
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
      if (!isAlreadyInAttacker(attacking_pieces, newRow, newCol) &&
          board[newRow][newCol]!.isWhite != kingPiece.isWhite &&
          board[newRow][newCol]!.type == ChessPieceType.knight) {
        attacking_pieces.add([newRow, newCol]); // can kill
      }
      continue; // blocked
    }
  }

  // BISHOPS ( top_left top_right bottom_left bottom_right )
  final bishopMoves = [
    [-1, -1], // up left
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
        if (!isAlreadyInAttacker(attacking_pieces, newRow, newCol) &&
            board[newRow][newCol]!.isWhite != kingPiece.isWhite &&
            board[newRow][newCol]!.type == ChessPieceType.bishop) {
          attacking_pieces.add([newRow, newCol]); // can kill
        }
        break; // blocked
      }

      i++;
    }
  }

  // QUEEN ( bishop + rook )
  final queenMoves = [
    [-1, 0], // up
    [1, 0], // down
    [0, -1], // left
    [0, 1], // right
    [-1, -1], // up left
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
        if (!isAlreadyInAttacker(attacking_pieces, newRow, newCol) &&
            board[newRow][newCol]!.isWhite != kingPiece.isWhite &&
            board[newRow][newCol]!.type == ChessPieceType.queen) {
          attacking_pieces.add([newRow, newCol]); // can kill
        }
        break; // blocked
      }

      i++;
    }
  }
  print(attacking_pieces);

  return attacking_pieces;
}
