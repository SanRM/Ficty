import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/player/ball.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
}

class Player extends SpriteAnimationComponent with HasGameRef<RobotsGame>, CollisionCallbacks {
  Player({this.character = 'Ninja Frog'}) : super() {
    //debugMode = true;
    debugColor = const Color.fromARGB(255, 0, 255, 136);
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
  bool isFirstTime = true;
  double buffer = 20.0; 

  @override
  FutureOr<void> onLoad() async {
    _loadAnimations();

    _respawn();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (x < game.esfera.value.x - buffer) {
      if (isRightFacing) {
        flipHorizontallyAroundCenter();
        isRightFacing = false;
        
      }
    } else if (x > game.esfera.value.x + buffer) {
      if (!isRightFacing) {
        flipHorizontallyAroundCenter();
        isRightFacing = true;
        
      }
    }
  
    //print('is right facing: $isRightFacing');

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

    //current animation
    //animation = animationsList[PlayerState.falling];
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
    if (other is Ball) {
      //print('Ball collided with player');
      animation = animationsList[PlayerState.jumping];
      Future.delayed(const Duration(milliseconds: 350), () {
        animation = animationsList[PlayerState.idle];
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  void _respawn() {

    add(
      RectangleHitbox(collisionType: CollisionType.active),
    );

    Vector2 targetPosition = game.target.value;
    anchor = Anchor.topRight;

    add(
      MoveToEffect(
        targetPosition,
        EffectController(duration: 1, curve: Curves.decelerate),
        onComplete: () {
          animation = animationsList[PlayerState.idle];
        },
      ),
    );
    animation = animationsList[PlayerState.falling];

  }
}
