import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
}

class Player extends SpriteAnimationComponent with HasGameRef<RobotsGame>, KeyboardHandler {
  Player({
    this.character = 'Ninja Frog',
  }) : super() {
    debugMode = true;
    debugColor = Colors.green;
  }

  final String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;

  late final Map animationsList;

  bool isRightFacing = false;

  @override
  FutureOr<void> onLoad() async {
    _loadAnimations();

    return super.onLoad();
  }

  _loadAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;

    animationsList = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
    };

    animation = animationsList[PlayerState.idle];
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeftKeyPressed) {

      animation = animationsList[PlayerState.running];
      if (!isRightFacing) {
        flipHorizontallyAroundCenter();
        isRightFacing = true;
      }

    } else if (isRightKeyPressed) {

      animation = animationsList[PlayerState.running];
      if (isRightFacing) {
        flipHorizontallyAroundCenter();
        isRightFacing = false;
      }

    } else {
      animation = animationsList[PlayerState.idle];
    }


    return super.onKeyEvent(event, keysPressed);
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
