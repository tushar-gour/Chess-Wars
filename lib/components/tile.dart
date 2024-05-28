import 'package:chess/components/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoardTile extends StatelessWidget {
  final bool isDarkTile;
  final ChessPiece? piece;
  final bool isValidMove;
  final bool isSelected;
  final bool isKingAttaked;
  final bool isInAttack;
  final void Function() onTap;

  const BoardTile({
    super.key,
    required this.isDarkTile,
    required this.piece,
    required this.isSelected,
    required this.isKingAttaked,
    required this.isInAttack,
    required this.isValidMove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration(
      color: isSelected
          ? isDarkTile
              ? selectedDarkPieceColor
              : selectedLightPieceColor
          : isDarkTile
              ? darkTileColor
              : lightTileColor,
    );

    if (isSelected) {
      decoration = BoxDecoration(
        color: isSelected
            ? isDarkTile
                ? selectedDarkPieceColor
                : selectedLightPieceColor
            : isDarkTile
                ? darkTileColor
                : lightTileColor,
        gradient: RadialGradient(
          radius: 1,
          colors: [
            isDarkTile ? darkTileColor : lightTileColor,
            isDarkTile ? selectedDarkPieceColor : selectedLightPieceColor,
          ],
        ),
      );
    }

    if (isInAttack) {
      decoration = BoxDecoration(
        color: isSelected
            ? isDarkTile
                ? selectedDarkPieceColor
                : selectedLightPieceColor
            : isDarkTile
                ? darkTileColor
                : lightTileColor,
        gradient: RadialGradient(
          radius: 1,
          colors: [
            isDarkTile ? darkTileColor : lightTileColor,
            inAttackPieceColor,
          ],
        ),
      );
    }

    if (isKingAttaked) {
      decoration = BoxDecoration(
        color: isSelected
            ? isDarkTile
                ? selectedDarkPieceColor
                : selectedLightPieceColor
            : isDarkTile
                ? darkTileColor
                : lightTileColor,
        gradient: RadialGradient(
          radius: 1,
          colors: [
            isDarkTile ? darkTileColor : lightTileColor,
            kingInAttackColor,
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: decoration,
        child: Stack(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: piece != null
                  ? piece!.isWhite
                      ? Image.asset(
                          piece!.imagePath,
                          color: piece!.isWhite
                              ? whitePieceColor
                              : blackPieceColor,
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(math.pi),
                          child: Image.asset(
                            piece!.imagePath,
                            color: piece!.isWhite
                                ? whitePieceColor
                                : blackPieceColor,
                          ),
                        )
                  : null,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isValidMove ? validMoveTileColor : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isValidMove ? Colors.black : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
