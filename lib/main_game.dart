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
              timer.cancel();
              _timer?.cancel();
              showTimeUpDialogue();
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

  void showTimeUpDialogue() {
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: AlertDialog(
          backgroundColor: dialogueColor,
          title: Center(
            child: Text(
              "TIME UP !!",
              style: TextStyle(
                color: lightTileColor,
                fontFamily: "Changa",
              ),
            ),
          ),
          content: InkWell(
            onTap: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Ink(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: darkTileColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'New Game',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Changa",
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showResetDialogue() {
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: AlertDialog(
          backgroundColor: dialogueColor,
          title: Center(
            child: Text(
              "Reset Game?",
              style: TextStyle(
                color: lightTileColor,
                fontFamily: "Changa",
              ),
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Changa",
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Changa",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
      if (isWhiteTurn) {
        whiteKingAttackers = isKingInCheck(
          board,
          whiteKingCord[0],
          whiteKingCord[1],
        );
      } else {
        blackKingAttackers = isKingInCheck(
          board,
          blackKingCord[0],
          blackKingCord[1],
        );
      }
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
          // Select a new piece of the same color
          setState(() {
            selectedPiece = piece;
            selectedCord = [row, col];
            calculateValidMoves();
          });
        } else {
          // Capture the piece
          if (isValidMove(row, col)) {
            setState(() {
              if (piece.isWhite) {
                whites_killed.add(piece);
              } else {
                blacks_killed.add(piece);
              }

              board[row][col] = selectedPiece;
              board[selectedCord[0]][selectedCord[1]] = null;

              if (selectedPiece!.type == ChessPieceType.king) {
                selectedPiece!.isWhite
                    ? {
                        whiteKingCord = [row, col],
                      }
                    : {
                        blackKingCord = [row, col],
                      };
              }

              isWhiteTurn = !isWhiteTurn;

              checkKingInCheck();
              removeSelectedPiece();
            });
          }
        }
      } else {
        // Select a piece if it's the player's turn
        if (piece.isWhite == isWhiteTurn) {
          setState(() {
            selectedPiece = piece;
            selectedCord = [row, col];
            calculateValidMoves();
          });
        }
      }
    } else {
      // Move the piece to an empty tile
      if (selectedPiece != null && isValidMove(row, col)) {
        setState(() {
          board[row][col] = selectedPiece;
          board[selectedCord[0]][selectedCord[1]] = null;
          isWhiteTurn = !isWhiteTurn;
          checkKingInCheck();
          removeSelectedPiece();
        });
      } else {
        setState(() {
          removeSelectedPiece();
        });
      }
    }
  }

  bool isKingAttacker(int row, int col) {
    if (whiteKingAttackers.isNotEmpty)
      for (var pair in whiteKingAttackers) {
        if (pair[0] == row && pair[1] == col) return true;
      }

    if (blackKingAttackers.isNotEmpty)
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
              onPressed: showResetDialogue,
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
                  color: Colors.grey.shade200,
                  fontSize: 25,
                ),
              ),
              Text(
                "WARS",
                style: TextStyle(
                  fontFamily: "Changa",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
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
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: InkWell(
                      onTap: () {},
                      child: Ink(
                        width: 200,
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            'Surrender',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Changa",
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        formattedTime(blackTime),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Changa",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
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
                  bool isKingAttakedOrIsAttacker = false;

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
                    isKingAttakedOrIsAttacker = myPiece.isWhite
                        ? whiteKingAttackers.isNotEmpty
                        : blackKingAttackers.isNotEmpty;
                  }

                  if (myPiece != null && !isKingAttakedOrIsAttacker) {
                    isKingAttakedOrIsAttacker = isKingAttacker(
                      myCord[0],
                      myCord[1],
                    );
                  }

                  return BoardTile(
                    isDarkTile: isDarkTile(index),
                    piece: myPiece,
                    isSelected: isSelected,
                    isKingAttaked: isKingAttakedOrIsAttacker,
                    isInAttack: isInAttack,
                    isValidMove: validMove,
                    onTap: () => onTileTap(myCord),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: InkWell(
                      onTap: () {},
                      child: Ink(
                        width: 200,
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            'Surrender',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Changa",
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        formattedTime(whiteTime),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Changa",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
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
