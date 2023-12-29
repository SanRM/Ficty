import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

class RobotEnemy extends Enemy {
  RobotEnemy({required spawnPoint}) : super(spawnPoint) {
    // Initialize Robot-specific properties here
  }
  
  //10. Not necesary to override but it's here for reference purposes, the default value is true
  @override
  void spawnEffects(bool enabled) {
    super.spawnEffects(true);
  }

  @override
  onLoad() async {
    
    character = 'Bunny';
    lifePoints = 3; 

    //_spawnRobot();

    return super.onLoad();
  }

  //Specific Robot methods here
 @override
  loadAnimations() {
    idleAnimation = spriteAnimation('Idle', 8);
    hitAnimation = spriteAnimation('Hit', 5)..loop = false;
    appearingAnimation = specialSpriteAnimation('Appearing', 7);

    animationsList = {
      EnemyState.idle: idleAnimation,
      EnemyState.hit: hitAnimation,
    };

    animation = animationsList[EnemyState.idle];
  }

  @override
  SpriteAnimation spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/$character/$state (34x44).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(34, 44),
      ),
    );
  }



}