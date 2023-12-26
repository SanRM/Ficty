import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';
import 'package:flutter_flame_game/game/player/ball.dart';

class ShieldBearer extends Enemy {
  ShieldBearer(this.spawnPoint) : super(spawnPoint);

  final Vector2 spawnPoint;

  @override
  FutureOr<void> onLoad() {
    
    character = 'Virtual Guy';

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    
    if (other is Ball && !collidedBalls.contains(other)) {

      game.esfera.value.resetBall;

      collidedBalls.add(other);
      lifePoints--;

      //print('shieldBearer lifePoints: $lifePoints');

      animation = animationsList[EnemyState.hit];

      Future.delayed(Duration(milliseconds: 350), () {
        animation = animationsList[EnemyState.idle];
      });
    }

    super.onCollision(intersectionPoints, other);
  }
  

}