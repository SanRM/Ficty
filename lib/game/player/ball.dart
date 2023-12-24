import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/utils/ball_effects.dart';
import 'package:flutter_flame_game/game/utils/collision_block.dart';
import 'package:flutter_flame_game/game/robots_game.dart';
//import 'package:flutter_flame_game/game/utils/player_effects.dart';

// enum BallState {
//   inactive,
//   active
// }

class Ball extends CircleComponent
    with HasGameRef<RobotsGame>, CollisionCallbacks {
  double playerX;
  double playerY;

  Ball({required this.playerX, required this.playerY}) {
    paint = Paint()..color = Colors.transparent;
    radius = 5;
    //debugMode = true;
    debugColor = Colors.pink;
  }

  Vector2 velocity = Vector2.zero();
  double speed = 9;
  BallEffects ballEffects = BallEffects();
  int collisionCount = 0;
  Random random = new Random();

  // 6.
  @override
  onLoad() {
    resetBall;
    final hitBox = CircleHitbox(isSolid: true, collisionType: CollisionType.active);

    addAll([hitBox, ballEffects]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt * speed;

    //print(collisionCount);
    if (collisionCount > 5) {
      resetBall;
    }
  }

  // 4.
  void get resetBall {
    position = Vector2(game.target.value.x + 10, game.target.value.y + 10);
    collisionCount = 0;
    velocity = Vector2(0, 0);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollisionBlock) {
      // Determine the side of the collision
      double otherBottom = other.position.y + other.size.y;
      double otherRight = other.position.x + other.size.x;

      bool isTop = false;
      bool isRight = false;
      bool isLeft = false;
      bool isBottom = false;

      for (Vector2 collisionPoint in intersectionPoints) {
        isBottom = isBottom || collisionPoint.y <= other.position.y;
        isTop = isTop || (!isBottom && collisionPoint.y >= otherBottom);
        isRight = isRight || collisionPoint.x <= other.position.x;
        isLeft = isLeft || (!isRight && collisionPoint.x >= otherRight);
      }

      // Reposition the ball outside of the block
      if (isBottom && !isTop) {
        position.y = other.position.y - size.y;
        velocity.y *= -1; // Change the direction of the velocity
      } else if (isTop && !isBottom) {
        position.y = otherBottom;
        velocity.y *= -1; // Change the direction of the velocity
      }

      if (isRight && !isLeft) {
        position.x = other.position.x - size.x;
        velocity.x *= -1; // Change the direction of the velocity
      } else if (isLeft && !isRight) {
        position.x = otherRight;
        velocity.x *= -1; // Change the direction of the velocity
      }

      // If the ball hits a corner, make it bounce off in a different direction
      if ((isTop && isRight) ||
          (isTop && isLeft) ||
          (isBottom && isRight) ||
          (isBottom && isLeft)) {
        double temp = velocity.x;
        velocity.x = velocity.y;
        velocity.y = temp;
      }

      // If the ball hits a corner, make it bounce off in a different direction
      if ((isTop && isRight) ||
          (isTop && isLeft) ||
          (isBottom && isRight) ||
          (isBottom && isLeft)) {
        double temp = velocity.x;
        velocity.x = velocity.y +
            (0.2 * random.nextDouble() -
                0.1); // Add a small amount of random noise
        velocity.y = temp +
            (0.2 * random.nextDouble() -
                0.1); // Add a small amount of random noise
      }

      collisionCount++;

      super.onCollision(intersectionPoints, other);
    }
  }
}
