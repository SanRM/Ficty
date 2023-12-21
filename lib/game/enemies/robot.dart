import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/player/ball.dart';
import 'package:flutter_flame_game/game/robots_game.dart';
import 'package:flutter_flame_game/game/utils/player_effects.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
}

class Robot extends SpriteAnimationComponent
    with HasGameRef<RobotsGame>, CollisionCallbacks {
  Robot({
    this.character = 'Mask Dude',
  }) : super() {
    //debugMode = true;
    debugColor = Colors.red;
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
  final double stepTime = 0.05;
  int lifePoints = 2;
  List<Ball> collidedBalls = [];
  bool isActive = true;

  TextComponent lifePointsText = TextComponent();

  @override
  FutureOr<void> onLoad() async {
    lifePointsText = TextComponent(text: '$lifePoints', position: -Vector2(-15, 15), scale: Vector2.all(0.5));

    _loadAnimations();
    _spawnRobot();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isActive) {
      collidedBalls
          .removeWhere((ball) => !this.toRect().overlaps(ball.toRect()));

      lifePointsText.text = '$lifePoints';
      add(lifePointsText);

      if (lifePoints == 0) {
        print('Robot died');
        _die();
      }
    }
  }

  _loadAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);

    animationsList = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
    };

    animation = animationsList[PlayerState.idle];
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball && !collidedBalls.contains(other)) {
      collidedBalls.add(other);
      lifePoints--;
      print(lifePoints);
      animation = animationsList[PlayerState.hit];

      Future.delayed(Duration(milliseconds: 350), () {
        animation = animationsList[PlayerState.idle];
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  void _spawnRobot() {
    add(
      RectangleHitbox(collisionType: CollisionType.active),
    );

    animation = animationsList[PlayerState.idle];
  }

  void _die() {
    isActive = false;

    gameRef.healthImage.value = gameRef.healthImage.value - 2;

    lifePointsText.text = '';
    lifePoints = 2;

    PlayerEffects effects = PlayerEffects();

    add(effects);

    effects.position = Vector2.all(0) - Vector2.all(32);

    effects.animation = effects.animationsList[PlayerEffectState.desappearing];

    Future.delayed(Duration(milliseconds: 350), () {
      effects.animation = effects.animationsList[PlayerEffectState.nullState];
      this.setOpacity(0);
    });

    game.enemiesKilled.value++;
  }
}
