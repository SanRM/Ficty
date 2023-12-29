import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/levels.dart/level.dart';
import 'package:flutter_flame_game/game/player/ball.dart';
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

  // Player player = Player(
  //   character: 'Ninja Frog',
  // );

  final String chapter;
  late CameraComponent cam;

  ValueNotifier enemiesCount = ValueNotifier<int>(0);
  ValueNotifier enemiesKilled = ValueNotifier<int>(0);
  ValueNotifier numberOfShots = ValueNotifier<int>(0);
  ValueNotifier health = ValueNotifier<int>(0);

  ValueNotifier target = ValueNotifier<Vector2>(Vector2.zero());

  ValueNotifier<bool> isGameplayActive = ValueNotifier<bool>(false);
  ValueNotifier<Ball> esfera = ValueNotifier<Ball>(Ball(playerX: 0, playerY: 0));
  ValueNotifier<Player> player = ValueNotifier<Player>(Player(character: 'Ninja Frog',));

  ValueNotifier<AudioPlayer> audioPlayer = ValueNotifier(AudioPlayer());
  ValueNotifier<bool> playSounds = ValueNotifier<bool>(true);
  ValueNotifier<double> soundVolume = ValueNotifier<double>(1.0);

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  // @override
  // Color backgroundColor() => const Color.fromARGB(255, 144, 229, 255);

  _loadLevel() async {
    
      Level world = Level(
        player: player.value,
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
    
  }
}
