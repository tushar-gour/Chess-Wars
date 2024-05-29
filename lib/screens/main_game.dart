import 'dart:async';
import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/tile.dart';
import 'package:chess/functions/check_checkmate.dart';
import 'package:chess/functions/helpers.dart';
import 'package:chess/functions/king_ckeck.dart';
import 'package:chess/functions/moves/real_moves.dart';
import 'package:chess/functions/new_board.dart';
import 'package:chess/functions/sounds.dart';
import 'package:chess/functions/two_king_remaining.dart';
import 'package:chess/values/colors.dart';
import 'package:chess/values/globals.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      setState(() {
        if (!isGameStarted) {
          timer.cancel();
          return;
        }

        if (isWhiteTurn) {
          whiteTime -= 1;
        } else {
          blackTime -= 1;
        }

        if (whiteTime <= 0 || blackTime <= 0) {
          timer.cancel();
          _timer?.cancel();
          showTimeUpDialog();
        }
      });
    });
  }

  void showTimeUpDialog() {
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

  void showTieDialog() {
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
              "!! TIE !!",
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

  void showCheckmateDialog() {
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
              "CHECKMATE !!",
              style: TextStyle(
                color: lightTileColor,
                fontFamily: "Changa",
              ),
            ),
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Text(
                  '${isWhiteTurn ? 'Black' : 'White'} Won the match!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Changa",
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showResetDialog() {
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

  void showReviveDialog(int row, int col) {
    final deadPieces = isWhiteTurn
        ? canReviveDeadPieces(whites_killed)
        : canReviveDeadPieces(blacks_killed);

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
          content: Column(
            children: [
              Text(
                'Tap on a piece to revive:',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Changa",
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 100,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: deadPieces.length,
                  itemBuilder: (ctx, index) => DeadPiece(
                    imagePath: deadPieces[index].imagePath,
                    isWhite: deadPieces[index].isWhite,
                    canFlip: false,
                    onTap: () {
                      Navigator.pop(context);
                      onRevive(row, col, deadPieces[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ChessPiece? getPieceFromCoordinates(List<int> coordinates) {
    return board[coordinates[0]][coordinates[1]];
  }

  void _initializeBoard() {
    playSound('sounds/gameStart.mp3');
    board = newBoard();
    selectedPiece = null;
    selectedCord = [-1, -1];
    whiteKingCord = [7, 3];
    blackKingCord = [0, 4];
    whiteTime = CHESS_TIME;
    blackTime = CHESS_TIME;
    isWhiteTurn = true;
    isWhiteKingInCheck = false;
    isBlackKingInCheck = false;
    valid_moves.clear();
    whites_killed.clear();
    blacks_killed.clear();
    whiteKingAttackers.clear();
    blackKingAttackers.clear();
    _timer?.cancel();
    setState(() {});
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
    clearValidMoves();

    valid_moves = getRealMoves(
      board,
      selectedPiece,
      selectedCord,
      isWhiteTurn,
      isWhiteTurn ? whiteKingCord : blackKingCord,
    );

    setState(() {});
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

  void checkGameOver() {
    if (isKingsRemaining(board)) {
      showTieDialog();
    } else if (isCheckmate(
      board,
      isWhiteTurn,
      isWhiteTurn ? whiteKingCord : blackKingCord,
    )) {
      showCheckmateDialog();
    }
  }

  void onRevive(int row, int col, ChessPiece revivedPiece) {
    setState(() {
      board[row][col] = revivedPiece;
      updateOtherStuffs();
    });
  }

  List<ChessPiece> canReviveDeadPieces(List<ChessPiece> deadPieces) {
    List<ChessPiece> canRevive = [];

    for (var piece in deadPieces) {
      if (piece.type != ChessPieceType.pawn) canRevive.add(piece);
    }

    return canRevive;
  }

  bool canRevive(int row, int col) {
    final ChessPiece? piece = board[row][col];

    if (piece!.type == ChessPieceType.pawn) {
      if ((isWhiteTurn &&
              canReviveDeadPieces(whites_killed).length > 0 &&
              piece.isWhite &&
              row == 0) ||
          (!isWhiteTurn &&
              canReviveDeadPieces(blacks_killed).length > 0 &&
              !piece.isWhite &&
              row == 7)) {
        return true;
      }
    }

    return false;
  }

  void updateOtherStuffs() {
    isWhiteTurn = !isWhiteTurn;
    checkKingInCheck();
    removeSelectedPiece();
    checkGameOver();
  }

  void updateMovedPiece(int row, int col) {
    board[row][col] = selectedPiece;
    board[selectedCord[0]][selectedCord[1]] = null;
    updateKingPositionIfNeeded(row, col);
    if (canRevive(row, col)) {
      showReviveDialog(row, col);
    } else {
      updateOtherStuffs();
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
            playSound('sounds/capture.mp3');
            (piece.isWhite ? whites_killed : blacks_killed).add(piece);
            updateMovedPiece(row, col);
          }
        } else if (piece.isWhite == isWhiteTurn) {
          // Select a piece
          selectedPiece = piece;
          selectedCord = [row, col];
          calculateValidMoves();
        }
      } else if (selectedPiece != null && isValidMove(row, col)) {
        // Move the piece
        playSound('sounds/move.mp3');
        updateMovedPiece(row, col);
      } else {
        removeSelectedPiece();
      }
    });
  }

  bool isKingAttackedOrIsAttacker(int row, int col) {
    if (whiteKingAttackers.isEmpty && blackKingAttackers.isEmpty) return false;

    if (whiteKingAttackers.isNotEmpty) {
      for (var pair in whiteKingAttackers) {
        if (pair[0] == row && pair[1] == col) return true;
      }
    }

    if (blackKingAttackers.isNotEmpty) {
      for (var pair in blackKingAttackers) {
        if (pair[0] == row && pair[1] == col) return true;
      }
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
        appBar: AppBar(
          backgroundColor: appBarColor,
          actions: [
            IconButton(
              onPressed: showResetDialog,
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
            _buildBlackControlRow(blackTime),
            _buildChessBoard(screenWidth),
            _buildWhiteControlRow(whiteTime),
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
          canFlip: true,
          onTap: null,
        ),
      ),
    );
  }

  Widget _buildWhiteControlRow(int time) {
    return SizedBox(
      height: 30,
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
    );
  }

  Widget _buildBlackControlRow(int time) {
    return SizedBox(
      height: 30,
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(math.pi),
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

          bool isSelected =
              myCord[0] == selectedCord[0] && myCord[1] == selectedCord[1];
          bool validMove = valid_moves
              .any((pair) => pair[0] == myCord[0] && pair[1] == myCord[1]);

          bool isInAttack = validMove &&
              board[myCord[0]][myCord[1]] != null &&
              board[myCord[0]][myCord[1]]!.isWhite == !isWhiteTurn;

          bool isKingAttacked =
              myPiece != null && myPiece.type == ChessPieceType.king
                  ? (myPiece.isWhite
                      ? whiteKingAttackers.isNotEmpty
                      : blackKingAttackers.isNotEmpty)
                  : isKingAttackedOrIsAttacker(myCord[0], myCord[1]);

          return BoardTile(
            isDarkTile: isDarkTile(index),
            piece: myPiece,
            isSelected: isSelected,
            isKingAttaked: isKingAttacked,
            isInAttack: isInAttack,
            isValidMove: validMove,
            onTap: () => onTileTap(myCord),
          );
        },
      ),
    );
  }
}
