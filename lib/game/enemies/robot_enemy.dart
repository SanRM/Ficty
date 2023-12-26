import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

class RobotEnemy extends Enemy {
  RobotEnemy(this.spawnPoint) : super(spawnPoint) {
    // Initialize Robot-specific properties here
  }

  final Vector2 spawnPoint;
  
  //10. Not necesary to override but it's here for reference purposes, the default value is true
  @override
  void spawnEffects(bool enabled) {
    super.spawnEffects(true);
  }

  @override
  onLoad() async {
    
    character = 'Mask Dude';
    lifePoints = 3; 

    //_spawnRobot();

    return super.onLoad();
  }

  //Specific Robot methods here

}