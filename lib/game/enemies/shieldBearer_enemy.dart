import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

class ShieldBearer extends Enemy {
  ShieldBearer({required this.spawnPoint}) : super(spawnPoint);

  final Vector2 spawnPoint;

  @override
  FutureOr<void> onLoad() {
    
    //character = 'Virtual Guy';

    return super.onLoad();
  }

  

}