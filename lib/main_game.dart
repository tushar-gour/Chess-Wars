import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/tile.dart';
import 'package:chess/functions/helpers.dart';
import 'package:chess/functions/king_ckeck.dart';
import 'package:chess/functions/moves/real_moves.dart';
import 'package:chess/functions/new_board.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;

  List<List<int>> valid_moves = []; // [ [row, col] , [row, col] ]
  List<List<int>> blackKingAttackers = [];
  List<List<int>> whiteKingAttackers = [];

  List<ChessPiece> blacks_killed = [];
  List<ChessPiece> whites_killed = [];

  bool isWhiteKingInCheck = false;
  bool isBlackKingInCheck = false;

  bool isWhiteTurn = true;
  ChessPiece? selectedPiece;
  List<int> selectedCord = [-1, -1];
  List<int> whiteKingCord = [7, 3];
  List<int> blackKingCord = [0, 4];

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  ChessPiece? getPieceFromCoordinates(List<int> coordinates) {
    return board[coordinates[0]][coordinates[1]];
  }

  void _initializeBoard() {
    board = newBoard();
  }

  void removeSelectedPiece() {
    selectedCord = [-1, -1];
    selectedPiece = null;
    clearValidMoves();
  }

  void clearValidMoves() {
    setState(() {
      valid_moves.clear();
    });
  }

  void calculateRawValidMoves() {
    clearValidMoves();

    setState(() {
      valid_moves = getRealMoves(
        board,
        selectedPiece,
        selectedCord,
        isWhiteTurn,
        isWhiteTurn ? whiteKingCord : blackKingCord,
      );
    });
  }

  bool isValidMove(int row, int col) {
    for (var pair in valid_moves) {
      if (pair[0] == row && pair[1] == col) {
        return true;
      }
    }
    return false;
  }

  void checkKingInCheck() {
    setState(() {
      whiteKingAttackers = isKingInCheck(
        board,
        whiteKingCord[0],
        whiteKingCord[1],
      );

      blackKingAttackers = isKingInCheck(
        board,
        blackKingCord[0],
        blackKingCord[1],
      );
    });
  }

  void onTileTap(List<int> tileCoordinates) {
    /* ---- LOGIC ----
      asuming white's turn

      if tapped tile has a piece:
          if selected piece != null:
              if piece is of white color -> select new piece
              else -> kill
          
          else:
              if piece is of white color -> select piece
              else -> nothing

      if tapped tile is empty:
          if selected piece != null -> move piece
          else -> nothing
    */

    final row = tileCoordinates[0];
    final col = tileCoordinates[1];
    final piece = getPieceFromCoordinates(tileCoordinates);

    if (piece != null) {
      if (selectedPiece != null) {
        if (piece.isWhite == selectedPiece!.isWhite) {
          selectedPiece = piece;
          selectedCord = [row, col];
          calculateRawValidMoves();
        } else {
          // Kill / Capture the piece

          if (isValidMove(row, col)) {
            if (piece.isWhite) {
              whites_killed.add(piece);
            } else {
              blacks_killed.add(piece);
            }

            board[row][col] = selectedPiece;
            board[selectedCord[0]][selectedCord[1]] = null;

            isWhiteTurn = !isWhiteTurn;

            checkKingInCheck();
            removeSelectedPiece();
          }
        }
      } else {
        if (piece.isWhite == isWhiteTurn) {
          selectedPiece = piece;
          selectedCord = [row, col];
          calculateRawValidMoves();
        }
      }
    } else {
      if (selectedPiece != null) {
        // move piece
        // if this move is a valid move

        if (isValidMove(row, col)) {
          board[row][col] = selectedPiece;
          board[selectedCord[0]][selectedCord[1]] = null;
          isWhiteTurn = !isWhiteTurn;
          checkKingInCheck();
        }
        removeSelectedPiece();
      }
    }

    setState(() {});
  }

  bool isKingAttacker(int row, int col) {
    for (var pair in whiteKingAttackers) {
      if (pair[0] == row && pair[1] == col) return true;
    }

    for (var pair in blackKingAttackers) {
      if (pair[0] == row && pair[1] == col) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "CHESS WARS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: whites_killed.length,
                itemBuilder: (ctx, index) => DeadPiece(
                  imagePath: whites_killed[index].imagePath,
                  isWhite: whites_killed[index].isWhite,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 8 * 8,
                itemBuilder: (ctx, index) {
                  final myCord = getTileCoordinates(index);
                  final myPiece = getPieceFromCoordinates(myCord);

                  bool isSelected = myCord[0] == selectedCord[0] &&
                      myCord[1] == selectedCord[1];
                  bool validMove = false;
                  bool isInAttack = false;
                  bool isKingAttaked = false;

                  for (var pair in valid_moves) {
                    if (pair[0] == myCord[0] && pair[1] == myCord[1]) {
                      validMove = true;
                      if (board[pair[0]][pair[1]] != null &&
                          board[pair[0]][pair[1]]!.isWhite == !isWhiteTurn) {
                        isInAttack = true;
                      }
                      break;
                    }
                  }

                  if (myPiece != null && myPiece.type == ChessPieceType.king) {
                    isKingAttaked = myPiece.isWhite
                        ? whiteKingAttackers.isNotEmpty
                        : blackKingAttackers.isNotEmpty;
                  }

                  if (!isKingAttaked) {
                    isKingAttaked = isKingAttacker(
                      myCord[0],
                      myCord[1],
                    );
                  }
                  return BoardTile(
                    isDarkTile: isDarkTile(index),
                    piece: myPiece,
                    isSelected: isSelected,
                    isKingAttaked: isKingAttaked,
                    isInAttack: isInAttack,
                    isValidMove: validMove,
                    onTap: () => onTileTap(myCord),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: blacks_killed.length,
                itemBuilder: (ctx, index) => DeadPiece(
                  imagePath: blacks_killed[index].imagePath,
                  isWhite: blacks_killed[index].isWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
