import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/levels.dart/level_overlays/pause_manu.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

class PauseButton extends StatelessWidget {

  static const String id = 'PauseButton';
  final RobotsGame gameRef;

  const PauseButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.all(10),
        child: TextButton(
          onPressed: () {
            gameRef.pauseEngine();
            gameRef.overlays.add(PauseMenu.id);
            gameRef.overlays.remove(PauseButton.id);
          },
          child: const Icon(
            Icons.pause,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
