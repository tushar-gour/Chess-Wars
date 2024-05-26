import 'dart:async';

import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/tile.dart';
import 'package:chess/functions/helpers.dart';
import 'package:chess/functions/king_ckeck.dart';
import 'package:chess/functions/moves/real_moves.dart';
import 'package:chess/functions/new_board.dart';
import 'package:chess/functions/time_format.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

const CHESS_TIME = 1800;

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
  bool isGameStarted = false;

  ChessPiece? selectedPiece;

  List<int> selectedCord = [-1, -1];
  List<int> whiteKingCord = [7, 3];
  List<int> blackKingCord = [0, 4];

  int whiteTime = CHESS_TIME;
  int blackTime = CHESS_TIME;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void timeCounter() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (isGameStarted) {
            if (isWhiteTurn) {
              whiteTime -= 1;
            } else {
              blackTime -= 1;
            }

            if (whiteTime <= 0 || blackTime <= 0) {
              // TODO end game
              timer.cancel();
              _timer?.cancel();
            }
          }
        });
      },
    );
  }

  void resetGame() {
    setState(() {
      isGameStarted = false;
      selectedPiece = null;
      isWhiteTurn = true;

      selectedCord = [-1, -1];
      whiteKingCord = [7, 3];
      blackKingCord = [0, 4];

      valid_moves.clear();
      blacks_killed.clear();
      whites_killed.clear();
      whiteKingAttackers.clear();
      blackKingAttackers.clear();

      whiteTime = CHESS_TIME;
      blackTime = CHESS_TIME;

      _timer?.cancel();

      _initializeBoard();
    });
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

  void calculateValidMoves() {
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

    if (!isGameStarted) {
      setState(() {
        isGameStarted = true;
        timeCounter();
      });
    }

    final row = tileCoordinates[0];
    final col = tileCoordinates[1];
    final piece = getPieceFromCoordinates(tileCoordinates);

    if (piece != null) {
      if (selectedPiece != null) {
        if (piece.isWhite == selectedPiece!.isWhite) {
          selectedPiece = piece;
          selectedCord = [row, col];
          calculateValidMoves();
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
          calculateValidMoves();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          actions: [
            IconButton(
              onPressed: resetGame,
              icon: Icon(
                Icons.replay,
                color: Colors.white,
              ),
            ),
          ],
          title: Row(
            children: [
              Text(
                "CHESS ",
                style: TextStyle(
                  fontFamily: "Changa",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              Text(
                "WARS",
                style: TextStyle(
                  fontFamily: "Changa",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 100,
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
            Text(
              formattedTime(blackTime),
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Changa",
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: screenWidth,
              height: screenWidth,
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
            Text(
              formattedTime(whiteTime),
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Changa",
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 100,
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
