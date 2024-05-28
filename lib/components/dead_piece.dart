import 'package:flutter/material.dart';
import 'dart:math' as math;

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;

  const DeadPiece({
    super.key,
    required this.imagePath,
    required this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.all(5),
      color: const Color.fromARGB(100, 130, 130, 130),
      child: isWhite
          ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(math.pi),
              child: Image.asset(
                imagePath,
                color: isWhite ? Colors.white : Colors.black,
              ),
            )
          : Image.asset(
              imagePath,
              color: isWhite ? Colors.white : Colors.black,
            ),
    );
  }
}
