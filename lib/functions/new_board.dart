import 'package:chess/components/piece.dart';

List<List<ChessPiece?>> newBoard() {
  List<List<ChessPiece?>> newBoard = List.generate(
    8,
    (index) => List.generate(
      8,
      (index) => null,
    ),
  );

  // place pawns
  for (int i = 0; i < 8; i++) {
    newBoard[1][i] = ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: false,
      imagePath: 'assets/pieces/pawn.png',
    );
    newBoard[6][i] = ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: true,
      imagePath: 'assets/pieces/pawn.png',
    );
  }

  // place rooks
  newBoard[0][0] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: false,
    imagePath: 'assets/pieces/rook.png',
  );

  newBoard[0][7] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: false,
    imagePath: 'assets/pieces/rook.png',
  );

  newBoard[7][0] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: true,
    imagePath: 'assets/pieces/rook.png',
  );

  newBoard[7][7] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: true,
    imagePath: 'assets/pieces/rook.png',
  );

  // place knights
  newBoard[0][1] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: false,
    imagePath: 'assets/pieces/knight.png',
  );

  newBoard[0][6] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: false,
    imagePath: 'assets/pieces/knight.png',
  );

  newBoard[7][1] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: true,
    imagePath: 'assets/pieces/knight.png',
  );

  newBoard[7][6] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: true,
    imagePath: 'assets/pieces/knight.png',
  );

  // place bishops
  newBoard[0][2] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: false,
    imagePath: 'assets/pieces/bishop.png',
  );

  newBoard[0][5] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: false,
    imagePath: 'assets/pieces/bishop.png',
  );

  newBoard[7][2] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: true,
    imagePath: 'assets/pieces/bishop.png',
  );

  newBoard[7][5] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: true,
    imagePath: 'assets/pieces/bishop.png',
  );

  // place queens
  newBoard[0][3] = ChessPiece(
    type: ChessPieceType.queen,
    isWhite: false,
    imagePath: 'assets/pieces/queen.png',
  );

  newBoard[7][4] = ChessPiece(
    type: ChessPieceType.queen,
    isWhite: true,
    imagePath: 'assets/pieces/queen.png',
  );

  // place kings
  newBoard[0][4] = ChessPiece(
    type: ChessPieceType.king,
    isWhite: false,
    imagePath: 'assets/pieces/king.png',
  );

  newBoard[7][3] = ChessPiece(
    type: ChessPieceType.king,
    isWhite: true,
    imagePath: 'assets/pieces/king.png',
  );

  return newBoard;
}
