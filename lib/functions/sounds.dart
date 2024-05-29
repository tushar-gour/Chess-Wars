import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

Future<void> playSound(String audioPath) async {
  await player.play(
    AssetSource(audioPath),
  );
}
