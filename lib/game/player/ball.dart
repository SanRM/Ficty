import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/utils/collision_block.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

class Ball extends CircleComponent with HasGameRef<RobotsGame>, CollisionCallbacks {
  double playerX;
  double playerY;

  Ball({required this.playerX, required this.playerY}) {
    paint = Paint()..color = Colors.transparent;
    radius = 5;
    debugMode = true;
  }

  late Vector2 velocity;
  double speed = 7;

  // 6.
  @override
  onLoad() {
    resetBall;
    final hitBox = CircleHitbox(isSolid: true, collisionType: CollisionType.active);

    addAll([
      hitBox,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt * speed;
  }

  // 4.
  void get resetBall {
    position = Vector2(playerX, playerY);

    velocity = Vector2(
      0,
      0,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollisionBlock) {
      // Determine the side of the collision
      Vector2 collisionPoint = intersectionPoints.first;
      double otherBottom = other.position.y + other.size.y;
      double otherRight = other.position.x + other.size.x;

      bool isTop = collisionPoint.y <= other.position.y;
      bool isBottom = !isTop && collisionPoint.y >= otherBottom;
      bool isLeft = collisionPoint.x <= other.position.x;
      bool isRight = !isLeft && collisionPoint.x >= otherRight;

      // Reflect the velocity based on the side of the collision
      if (isTop || isBottom) {
        velocity.y *= -1;
      }
      if (isLeft || isRight) {
        velocity.x *= -1;
      }

      // Reposition the ball outside of the block
      if (isTop) {
        position.y = other.position.y - size.y;
      } else if (isBottom) {
        position.y = otherBottom;
      } else if (isLeft) {
        position.x = other.position.x - size.x;
      } else if (isRight) {
        position.x = otherRight;
      }
    }

    super.onCollision(intersectionPoints, other);
  }
}
