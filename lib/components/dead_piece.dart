import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(2),
      color: const Color.fromARGB(100, 130, 130, 130),
      child: Image.asset(
        imagePath,
        color: isWhite ? Colors.white : Colors.black,
      ),
    );
  }
}
