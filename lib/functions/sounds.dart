import 'package:audioplayers/audioplayers.dart';

Future<void> playTileTapSound() async {
  final player = AudioPlayer();
  final audioPath = 'assets/audio/tap.mp3';

  await player.play(
    AssetSource(audioPath),
  );
}
