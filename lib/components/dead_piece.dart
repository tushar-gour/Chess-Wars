import 'package:flutter/material.dart';
import 'dart:math' as math;

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  final bool canFlip;
  final void Function()? onTap;

  const DeadPiece({
    super.key,
    required this.imagePath,
    required this.isWhite,
    required this.canFlip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (canFlip) {
      if (isWhite) {
        child = Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(math.pi),
          child: Image.asset(
            imagePath,
            color: isWhite ? Colors.white : Colors.black,
          ),
        );
      } else {
        child = Image.asset(
          imagePath,
          color: isWhite ? Colors.white : Colors.black,
        );
      }
    } else {
      child = Image.asset(
        imagePath,
        color: isWhite ? Colors.white : Colors.black,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.all(5),
        color: const Color.fromARGB(100, 130, 130, 130),
        child: child,
      ),
    );
  }
}
