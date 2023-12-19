
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CollisionBlock extends PositionComponent {

  CollisionBlock({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        ) {
    //debugMode = true;
    debugColor = Colors.cyan;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      collisionType: CollisionType.active,
      
    ));
    return super.onLoad();
  }

}