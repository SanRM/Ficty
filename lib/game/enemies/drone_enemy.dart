import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

class DroneEnemy extends Enemy {
  DroneEnemy({required spawnPoint, required this.target})
      : super(spawnPoint) {
    // Initialize Robot-specific properties here
  }

  final Vector2 target;

  //10. Not necesary to override but it's here for reference purposes, the default value is true
  @override
  void spawnEffects(bool enabled) {
    super.spawnEffects(true);
  }

  @override
  onLoad() async {
    character = 'BlueBird';
    lifePoints = 2;

    // add(
    //   TextComponent(
    //     text: 'Hola, esto es un test',
    //     position: -Vector2(0, 10),
    //     scale: Vector2.all(
    //       0.5,
    //     ),
    //   ),
    // );

    flipHorizontallyAroundCenter();
    anchor = Anchor.topRight;

    add(
      MoveToEffect(
        target,
        EffectController(
          curve: Curves.linear,
          speed: 100,
          reverseCurve: Curves.linear,
          reverseSpeed: 100,
          infinite: true,
          onMax: () {
            //print('Drone reached target');
            flipHorizontallyAroundCenter();
          },
          onMin: () {
            //print('Drone reached spawn point');
            flipHorizontallyAroundCenter();
          },
        ),
      ),
    );

    //_spawnRobot();

    return super.onLoad();
  }

  @override
  loadAnimations() {
    idleAnimation = spriteAnimation('Idle', 9);
    hitAnimation = spriteAnimation('Hit', 5)..loop = false;

    animationsList = {
      EnemyState.idle: idleAnimation,
      EnemyState.hit: hitAnimation,
    };

    animation = animationsList[EnemyState.idle];
  }

  @override
  SpriteAnimation spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }


}
