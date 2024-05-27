import 'dart:async';

import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/tile.dart';
import 'package:chess/functions/helpers.dart';
import 'package:chess/functions/king_ckeck.dart';
import 'package:chess/functions/moves/real_moves.dart';
import 'package:chess/functions/new_board.dart';
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void timeCounter() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (!isGameStarted) {
        timer.cancel();
        return;
      }
      setState(() {
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
      });
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
              _initializeBoard();
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
                      _initializeBoard();
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
    selectedPiece = null;
    selectedCord = [-1, -1];
    valid_moves.clear();
    isWhiteTurn = true;
    whiteKingCord = [7, 3];
    blackKingCord = [0, 4];
    isWhiteKingInCheck = false;
    isBlackKingInCheck = false;
    whites_killed.clear();
    blacks_killed.clear();
    whiteKingAttackers.clear();
    blackKingAttackers.clear();
  }

  void clearValidMoves() {
    valid_moves.clear();
  }

  void removeSelectedPiece() {
    selectedCord = [-1, -1];
    selectedPiece = null;
    clearValidMoves();
  }

  void calculateValidMoves() {
    print('triggered');
    clearValidMoves();
    print('cleared');

    setState(() {
      valid_moves = getRealMoves(
        board,
        selectedPiece,
        selectedCord,
        isWhiteTurn,
        isWhiteTurn ? whiteKingCord : blackKingCord,
      );
    });

    print('set new');
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
  }

  void updateKingPositionIfNeeded(int row, int col) {
    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingCord = [row, col];
      } else {
        blackKingCord = [row, col];
      }
    }
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
      isGameStarted = true;
      timeCounter();
    }

    final row = tileCoordinates[0];
    final col = tileCoordinates[1];
    final piece = getPieceFromCoordinates(tileCoordinates);

    setState(() {
      if (piece != null) {
        if (selectedPiece != null) {
          if (piece.isWhite == selectedPiece!.isWhite) {
            // Select a new piece
            selectedPiece = piece;
            selectedCord = [row, col];
            calculateValidMoves();
          } else if (isValidMove(row, col)) {
            // Capture the piece
            (piece.isWhite ? whites_killed : blacks_killed).add(piece);
            board[row][col] = selectedPiece;
            board[selectedCord[0]][selectedCord[1]] = null;
            updateKingPositionIfNeeded(row, col);
            isWhiteTurn = !isWhiteTurn;
            checkKingInCheck();
            removeSelectedPiece();
          }
        } else if (piece.isWhite == isWhiteTurn) {
          // Select a piece
          selectedPiece = piece;
          selectedCord = [row, col];
          calculateValidMoves();
        }
      } else if (selectedPiece != null && isValidMove(row, col)) {
        // Move the piece
        board[row][col] = selectedPiece;
        board[selectedCord[0]][selectedCord[1]] = null;
        updateKingPositionIfNeeded(row, col);
        isWhiteTurn = !isWhiteTurn;
        checkKingInCheck();
        removeSelectedPiece();
      } else {
        removeSelectedPiece();
      }
    });
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

  bool isPieceInAttack(List<int> myCord) {
    return valid_moves.any((move) =>
        move[0] == myCord[0] &&
        move[1] == myCord[1] &&
        getPieceFromCoordinates(myCord) != null);
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
              icon: Icon(Icons.replay, color: Colors.white),
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
            _buildDeadPiecesGrid(whites_killed),
            _buildControlRow(blackTime),
            _buildChessBoard(screenWidth),
            _buildControlRow(whiteTime),
            _buildDeadPiecesGrid(blacks_killed),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadPiecesGrid(List<ChessPiece> deadPieces) {
    return SizedBox(
      height: 100,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: deadPieces.length,
        itemBuilder: (ctx, index) => DeadPiece(
          imagePath: deadPieces[index].imagePath,
          isWhite: deadPieces[index].isWhite,
        ),
      ),
    );
  }

  Widget _buildControlRow(int time) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
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
                formattedTime(time),
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
    );
  }

  Widget _buildChessBoard(double screenWidth) {
    return SizedBox(
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

          return BoardTile(
            isDarkTile: isDarkTile(index),
            piece: myPiece,
            isSelected:
                myCord[0] == selectedCord[0] && myCord[1] == selectedCord[1],
            isKingAttaked: isKingAttacker(myCord[0], myCord[1]),
            isInAttack: isPieceInAttack(myCord),
            isValidMove: isValidMove(myCord[0], myCord[1]),
            onTap: () => onTileTap(myCord),
          );
        },
      ),
    );
  }
}
