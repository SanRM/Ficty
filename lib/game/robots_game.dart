import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/levels.dart/level.dart';
import 'package:flutter_flame_game/game/player/player.dart';

class RobotsGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        DragCallbacks,
        HasGameRef<RobotsGame> {
  final String levelName;
  final double responsiveWidth;
  final double responsiveHeight;

  RobotsGame({
    this.chapter = 'chapter-1',
    this.levelName = 'level-01',
    required this.responsiveWidth,
    required this.responsiveHeight,
  }) {
    //debugMode = true;
  }

  Player player = Player(
    character: 'Ninja Frog',
  );

  final String chapter;
  late CameraComponent cam;

  ValueNotifier enemiesCount = ValueNotifier<int>(0);
  ValueNotifier enemiesKilled = ValueNotifier<int>(0);
  ValueNotifier numberOfShots = ValueNotifier<int>(0);
  ValueNotifier healthImage = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  // @override
  // Color backgroundColor() => const Color.fromARGB(255, 144, 229, 255);

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelName,
        chapter: chapter,
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 768,
        height: 352,
      );

      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
