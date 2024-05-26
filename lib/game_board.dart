// import 'package:chess/components/dead_piece.dart';
// import 'package:chess/components/piece.dart';
// import 'package:chess/components/tile.dart';
// import 'package:chess/functions/helpers.dart';
// import 'package:chess/values/colors.dart';
// import 'package:flutter/material.dart';

// class OLDGameBoard extends StatefulWidget {
//   const OLDGameBoard({super.key});

//   @override
//   State<OLDGameBoard> createState() => _OLDGameBoardState();
// }

// class _OLDGameBoardState extends State<OLDGameBoard> {
//   // 2d array representing the chess board
//   // each position representing a piece or null
//   late List<List<ChessPiece?>> board;

//   // we can only select 1 piece at a time else its null
//   ChessPiece? selectedPiece;

//   // keep track of coordinates, -1 means nothing selected yet
//   int selectedRow = -1;
//   int selectedCol = -1;

//   // list of valid moves for selected piece
//   // representation in row and col
//   List<List<int>> validMoves = [];
//   List<ChessPiece> whitesKilled = [];
//   List<ChessPiece> blacksKilled = [];

//   // turns check
//   bool isWhiteTurn = true;

//   // initial position of kings to keep track of checks
//   List<int> whiteKingPosition = [7, 4];
//   List<int> blackKingPosition = [0, 4];
//   bool checkStatus = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeBoard();
//   }

//   // INITIALISE BOARD
//   void _initializeBoard() {
//     // position the piece initially at correct place
//     List<List<ChessPiece?>> newBoard = List.generate(
//       8,
//       (index) => List.generate(
//         8,
//         (index) => null,
//       ),
//     );

//     // place pawns
//     for (int i = 0; i < 8; i++) {
//       newBoard[1][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: false,
//         imagePath: 'lib/pieces/pawn.png',
//       );
//       newBoard[6][i] = ChessPiece(
//         type: ChessPieceType.pawn,
//         isWhite: true,
//         imagePath: 'lib/pieces/pawn.png',
//       );
//     }

//     // place rooks
//     newBoard[0][0] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: false,
//       imagePath: 'lib/pieces/rook.png',
//     );

//     newBoard[0][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: false,
//       imagePath: 'lib/pieces/rook.png',
//     );

//     newBoard[7][0] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: true,
//       imagePath: 'lib/pieces/rook.png',
//     );

//     newBoard[7][7] = ChessPiece(
//       type: ChessPieceType.rook,
//       isWhite: true,
//       imagePath: 'lib/pieces/rook.png',
//     );

//     // place knights
//     newBoard[0][1] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: false,
//       imagePath: 'lib/pieces/knight.png',
//     );

//     newBoard[0][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: false,
//       imagePath: 'lib/pieces/knight.png',
//     );

//     newBoard[7][1] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: true,
//       imagePath: 'lib/pieces/knight.png',
//     );

//     newBoard[7][6] = ChessPiece(
//       type: ChessPieceType.knight,
//       isWhite: true,
//       imagePath: 'lib/pieces/knight.png',
//     );

//     // place bishops
//     newBoard[0][2] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: false,
//       imagePath: 'lib/pieces/bishop.png',
//     );

//     newBoard[0][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: false,
//       imagePath: 'lib/pieces/bishop.png',
//     );

//     newBoard[7][2] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: true,
//       imagePath: 'lib/pieces/bishop.png',
//     );

//     newBoard[7][5] = ChessPiece(
//       type: ChessPieceType.bishop,
//       isWhite: true,
//       imagePath: 'lib/pieces/bishop.png',
//     );

//     // place queens
//     newBoard[0][3] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: false,
//       imagePath: 'lib/pieces/queen.png',
//     );

//     newBoard[7][4] = ChessPiece(
//       type: ChessPieceType.queen,
//       isWhite: true,
//       imagePath: 'lib/pieces/queen.png',
//     );

//     // place kings
//     newBoard[0][4] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: false,
//       imagePath: 'lib/pieces/king.png',
//     );

//     newBoard[7][3] = ChessPiece(
//       type: ChessPieceType.king,
//       isWhite: true,
//       imagePath: 'lib/pieces/king.png',
//     );

//     // set board
//     board = newBoard;
//   }

//   // SELECT A PIECE
//   void pieceSelected(int row, int col) {
//     setState(() {
//       // no piece has been selected yet
//       if (board[row][col] != null && selectedPiece == null) {
//         if (board[row][col]!.isWhite == isWhiteTurn) {
//           selectedPiece = board[row][col];
//           selectedRow = row;
//           selectedCol = col;
//         }
//       }

//       // there is one piece selected and user can select another one of their pieces
//       else if (board[row][col] != null &&
//           selectedPiece != null &&
//           board[row][col]!.isWhite == selectedPiece!.isWhite) {
//         selectedPiece = board[row][col];
//         selectedRow = row;
//         selectedCol = col;
//       }

//       // if a piece is selected, move it to new position
//       else if (selectedPiece != null &&
//           validMoves.any((move) => move[0] == row && move[1] == col)) {
//         movePiece(row, col);
//       }

//       // if piece is selected, calculate its valid moves
//       validMoves = calculateRealValidMoves(
//           selectedRow, selectedCol, selectedPiece, true);
//     });
//   }

//   // CALCULATE RAW VALID MOVES
//   List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
//     List<List<int>> validMoves = [];

//     if (piece == null) return validMoves;

//     // different direction based on piece
//     int direction = piece.isWhite ? -1 : 1;

//     switch (piece.type) {
//       case ChessPieceType.pawn:
//         // forward move if tile is not occupied
//         if (isInBoard(row + direction, col) &&
//             board[row + direction][col] == null) {
//           validMoves.add([row + direction, col]);
//         }

//         // 2 step movement initially
//         if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
//           if (isInBoard(row + 2 * direction, col) &&
//               board[row + 2 * direction][col] == null &&
//               board[row + direction][col] == null) {
//             validMoves.add([row + 2 * direction, col]);
//           }
//         }

//         // diagonal attack
//         if (isInBoard(row + direction, col - 1) &&
//             board[row + direction][col - 1] != null &&
//             board[row + direction][col - 1]!.isWhite != piece.isWhite) {
//           validMoves.add([row + direction, col - 1]);
//         }

//         if (isInBoard(row + direction, col + 1) &&
//             board[row + direction][col + 1] != null &&
//             board[row + direction][col + 1]!.isWhite != piece.isWhite) {
//           validMoves.add([row + direction, col + 1]);
//         }

//         break;
//       case ChessPieceType.rook:
//         // horizontal and vertical directions
//         final rookMoves = [
//           [-1, 0], // up
//           [1, 0], // down
//           [0, -1], // left
//           [0, 1] // right
//         ];

//         for (var move in rookMoves) {
//           int i = 1;
//           while (true) {
//             int newRow = row + i * move[0];
//             int newCol = col + i * move[1];

//             if (!isInBoard(newRow, newCol)) break;

//             if (board[newRow][newCol] != null) {
//               if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//                 validMoves.add([newRow, newCol]); // can kill
//               }
//               break; // blocked
//             }

//             validMoves.add([newRow, newCol]);
//             i++;
//           }
//         }

//         break;
//       case ChessPieceType.knight:
//         final knightMoves = [
//           [-2, -1],
//           [-2, 1],
//           [-1, -2],
//           [-1, 2],
//           [1, -2],
//           [1, 2],
//           [2, -1],
//           [2, 1],
//         ];

//         for (var move in knightMoves) {
//           int newRow = row + move[0];
//           int newCol = row + move[1];

//           if (!isInBoard(newRow, newCol)) continue;

//           if (board[newRow][newCol] != null) {
//             if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//               validMoves.add([newRow, newCol]); // can kill
//             }
//             continue; // blocked
//           }
//           validMoves.add([newRow, newCol]);
//         }

//         break;
//       case ChessPieceType.bishop:
//         // diagonal directions
//         final bishopMoves = [
//           [-1, -1], // up eft
//           [-1, 1], // up right
//           [1, -1], // down left
//           [1, 1], // down right
//         ];

//         for (var move in bishopMoves) {
//           int i = 1;
//           while (true) {
//             int newRow = row + i * move[0];
//             int newCol = col + i * move[1];

//             if (!isInBoard(newRow, newCol)) break;

//             if (board[newRow][newCol] != null) {
//               if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//                 validMoves.add([newRow, newCol]); // can kill
//               }
//               break; // blocked
//             }

//             validMoves.add([newRow, newCol]);
//             i++;
//           }
//         }

//         break;
//       case ChessPieceType.queen:
//         final queenMoves = [
//           [-1, 0], // up
//           [1, 0], // down
//           [0, -1], // left
//           [0, 1], // right
//           [-1, -1], // up eft
//           [-1, 1], // up right
//           [1, -1], // down left
//           [1, 1], // down right
//         ];

//         for (var move in queenMoves) {
//           int i = 1;
//           while (true) {
//             int newRow = row + i * move[0];
//             int newCol = col + i * move[1];

//             if (!isInBoard(newRow, newCol)) break;

//             if (board[newRow][newCol] != null) {
//               if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//                 validMoves.add([newRow, newCol]); // can kill
//               }
//               break; // blocked
//             }

//             validMoves.add([newRow, newCol]);
//             i++;
//           }
//         }

//         break;
//       case ChessPieceType.king:
//         final kingMoves = [
//           [-1, 0], // up
//           [1, 0], // down
//           [0, -1], // left
//           [0, 1], // right
//           [-1, -1], // up eft
//           [-1, 1], // up right
//           [1, -1], // down left
//           [1, 1], // down right
//         ];

//         for (var move in kingMoves) {
//           int newRow = row + move[0];
//           int newCol = col + move[1];

//           if (!isInBoard(newRow, newCol)) break;

//           if (board[newRow][newCol] != null) {
//             if (board[newRow][newCol]!.isWhite != piece.isWhite) {
//               validMoves.add([newRow, newCol]); // can kill
//             }
//             continue; // blocked
//           }

//           validMoves.add([newRow, newCol]);
//         }
//         break;
//       default:
//         return validMoves;
//     }

//     return validMoves;
//   }

//   // CALCULATE REAL VALID MOVES
//   List<List<int>> calculateRealValidMoves(
//       int row, int col, ChessPiece? piece, bool checkSimulation) {
//     List<List<int>> realValidMoves = [];
//     List<List<int>> rawMoves = calculateRawValidMoves(row, col, piece);

//     // filter out allmoves that would result in check
//     if (checkSimulation) {
//       for (var move in rawMoves) {
//         int endRow = move[0];
//         int endCol = move[1];

//         // simulate all possible future move to see if it is a check or not
//         if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
//           realValidMoves.add(move);
//         }
//       }
//     }

//     return realValidMoves;
//   }

//   // MOVE THE SELECTED PIECE
//   void movePiece(int newRow, int newCol) {
//     // if new position have enemy piece
//     if (board[newRow][newCol] != null) {
//       var capturedPiece = board[newRow][newCol];

//       if (capturedPiece!.isWhite) {
//         whitesKilled.add(capturedPiece);
//       } else {
//         blacksKilled.add(capturedPiece);
//       }
//     }

//     // if moved piece is a king
//     if (selectedPiece!.type == ChessPieceType.king) {
//       if (selectedPiece!.isWhite) {
//         whiteKingPosition = [newRow, newCol];
//       } else {
//         blackKingPosition = [newRow, newCol];
//       }
//     }

//     // move the piece and clear old spots
//     board[newRow][newCol] = selectedPiece;
//     board[selectedRow][selectedCol] = null;

//     // check if any king is under attack
//     if (isKingInCheck(!isWhiteTurn)) {
//       checkStatus = true;
//     } else {
//       checkStatus = false;
//     }

//     // clear selections
//     setState(() {
//       selectedPiece = null;
//       selectedRow = -1;
//       selectedCol = -1;
//     });

//     // check if it is a check mate
//     if (isCheckMate(isWhiteTurn)) {
//       String won = isWhiteTurn ? 'White' : 'Black';

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(
//             'CHECK MATE\n'
//             '$won has won the match!',
//           ),
//           actions: [
//             TextButton(
//               onPressed: resetGame,
//               child: const Text('Play Again'),
//             ),
//           ],
//         ),
//       );
//     }

//     // change turns
//     isWhiteTurn = !isWhiteTurn;
//   }

//   // IS KING IN CHECK
//   bool isKingInCheck(bool isWhiteKing) {
//     List<int> kingPosition =
//         isWhiteKing ? whiteKingPosition : blackKingPosition;

//     // if enemy piece can attack the king
//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         // skip empty tiles and piece of same color as king
//         if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
//           continue;
//         }

//         List<List<int>> pieceValidMoves =
//             calculateRealValidMoves(i, j, board[i][j], false);

//         if (pieceValidMoves.any((move) =>
//             move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
//           return true;
//         }
//       }
//     }

//     return false;
//   }

//   // SIMULATE FUTURE MOVE
//   bool simulatedMoveIsSafe(
//       ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
//     // save the current board state
//     ChessPiece? originalDestinationPiece = board[endRow][endCol];

//     // if piece is the king, save its current position and update to new one
//     List<int>? originalKingPosition;

//     if (piece.type == ChessPieceType.king) {
//       originalKingPosition =
//           piece.isWhite ? whiteKingPosition : blackKingPosition;

//       // update the king position
//       if (piece.isWhite) {
//         whiteKingPosition = [endRow, endCol];
//       } else {
//         blackKingPosition = [endRow, endCol];
//       }
//     }

//     // simulate the moves
//     board[endRow][endCol] = piece;
//     board[startRow][startCol] = null;

//     // check if the king is under attack
//     bool kingInCheck = isKingInCheck(piece.isWhite);

//     // restore board to original state
//     board[startRow][startCol] = piece;
//     board[endRow][endCol] = originalDestinationPiece;

//     // if piece was the king, restore its original position
//     if (piece.type == ChessPieceType.king) {
//       if (piece.isWhite) {
//         whiteKingPosition = originalKingPosition!;
//       } else {
//         blackKingPosition = originalKingPosition!;
//       }
//     }

//     // if king is in check it means move is not safe so we return opposite
//     return !kingInCheck;
//   }

//   // IS CHECK MATE
//   bool isCheckMate(bool isWhiteKing) {
//     if (!isKingInCheck(isWhiteKing)) return false;

//     for (int i = 0; i < 8; i++) {
//       for (int j = 0; j < 8; j++) {
//         // skip empty tiles and same color piece
//         if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
//           continue;
//         }

//         List<List<int>> pieceValidMoves =
//             calculateRealValidMoves(i, j, board[i][j], true);

//         if (pieceValidMoves.isNotEmpty) {
//           return false;
//         }
//       }
//     }

//     return true;
//   }

//   void resetGame() {
//     Navigator.pop(context);
//     _initializeBoard();
//     whitesKilled.clear();
//     blacksKilled.clear();
//     whiteKingPosition = [7, 4];
//     blackKingPosition = [0, 4];
//     isWhiteTurn = true;
//     checkStatus = false;

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: mainBgColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // WHITES KILLED
//           Expanded(
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemCount: whitesKilled.length,
//               itemBuilder: (ctx, index) => DeadPiece(
//                 imagePath: whitesKilled[index].imagePath,
//                 isWhite: whitesKilled[index].isWhite,
//               ),
//             ),
//           ),

//           // GAME BOARD
//           Expanded(
//             flex: 3,
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemCount: 8 * 8,
//               itemBuilder: (ctx, index) {
//                 // get row and column position of tile
//                 List<int> cord = getTileCoordinates(index);
//                 int row = cord[0];
//                 int col = cord[1];
//                 bool isSelected = selectedRow == row && selectedCol == col;
//                 bool isValid = false;

//                 for (var pos in validMoves) {
//                   if (pos[0] == row && pos[1] == col) {
//                     isValid = true;
//                     break;
//                   }
//                 }

//                 return BoardTile(
//                   isWhite: isWhite(index),
//                   piece: board[row][col],
//                   isSelected: isSelected,
//                   isValidMove: isValid,
//                   onTap: () => pieceSelected(row, col),
//                 );
//               },
//             ),
//           ),

//           // BLACK PIECES KILLED
//           Expanded(
//             child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8,
//               ),
//               itemCount: blacksKilled.length,
//               itemBuilder: (ctx, index) => DeadPiece(
//                 imagePath: blacksKilled[index].imagePath,
//                 isWhite: blacksKilled[index].isWhite,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
