import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

class DroneEnemy extends Enemy {
  DroneEnemy({required this.spawnPoint, required this.target})
      : super(spawnPoint) {
    // Initialize Robot-specific properties here
  }

  final Vector2 spawnPoint;
  final Vector2 target;

  //10. Not necesary to override but it's here for reference purposes, the default value is true
  @override
  void spawnEffects(bool enabled) {
    super.spawnEffects(true);
  }

  @override
  onLoad() async {
    character = 'Pink Man';
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
}
