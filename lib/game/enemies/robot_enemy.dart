import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

class RobotEnemy extends Enemy {
  RobotEnemy() : super() {
    // Initialize Robot-specific properties here
  }

  TextComponent lifePointsText = TextComponent();

  @override
  onLoad() async {
    lifePointsText = TextComponent(text: '$lifePoints', position: -Vector2(0, 10), scale: Vector2.all(0.5));

    character = 'Mask Dude';

    //_spawnRobot();

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle Robot-specific collision logic here
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update Robot-specific logic here
  }

  // Add any Robot-specific methods here
}