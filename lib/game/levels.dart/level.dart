// level.dart
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/enemies/robot.dart';
import 'package:flutter_flame_game/game/utils/collision_block.dart';
import 'package:flutter_flame_game/game/player/ball.dart';
//import 'package:flame/sprite.dart';
import 'package:flutter_flame_game/game/player/player.dart';
import 'package:flutter_flame_game/game/robots_game.dart';
import 'package:flutter_flame_game/game/utils/player_effects.dart';

class Level extends World
    with HasGameRef<RobotsGame>, CollisionCallbacks, DragCallbacks {
  final String levelName;
  final Player player;
  final String chapter;

  Level({
    required this.levelName,
    required this.player,
    required this.chapter,
  });

  late TiledComponent levelTiledComponent;
  late Offset _currentPosition;
  late Ball esfera;

  @override
  onLoad() async {
    print('Loading map...');

    levelTiledComponent = await TiledComponent.load(
        '$levelName.tmx', prefix: 'assets/tiles/$chapter/', Vector2.all(16));

    add(levelTiledComponent);

    _spawningObjects();

    _currentPosition = Offset(player.center[0], player.center[1]);

    _addCollisions();

    //print('Map loaded successfully');

    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    esfera.resetBall;

    _currentPosition = Offset(
        2 * player.center[0] - event.localStartPosition[0],
        2 * player.center[1] - event.localEndPosition[1]);

    Offset newPosition = Offset(
        2 * player.center[0] - event.localStartPosition[0],
        2 * player.center[1] - event.localEndPosition[1]);

    double distance =
        (newPosition - Offset(player.center[0], player.center[1])).distance;
    double radius = 50.0;

    if (distance > radius) {
      double scale = radius / distance;
      newPosition = Offset(
          player.center[0] + (newPosition.dx - player.center[0]) * scale,
          player.center[1] + (newPosition.dy - player.center[1]) * scale);
    } else {
      double scale = radius * distance;
      newPosition = Offset(
          player.center[0] - (newPosition.dx + player.center[0]) / scale,
          player.center[1] - (newPosition.dy + player.center[1]) / scale);
    }

    _currentPosition = newPosition;

    //print(_currentPosition);

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    
    esfera.velocity = Vector2(
      _currentPosition.dx - player.center[0],
      _currentPosition.dy - player.center[1],
    );

    esfera.paint.color = Colors.white;

    
    game.numberOfShots.value--;

    //print('velocity: ${esfera.velocity}');

    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 2.0;

    canvas.drawLine(
        Offset(player.center[0], player.center[1]), _currentPosition, paint);
  }

  void _addCollisions() {
    final collisionsLayer =
        levelTiledComponent.tileMap.getLayer<ObjectGroup>('collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'block':
            //print('block detected at ${collision.x}, ${collision.y}');
            final CollisionBlock block = CollisionBlock(
              position: Vector2(
                collision.x,
                collision.y,
              ),
              size: Vector2(
                collision.width,
                collision.height,
              ),
            );
            add(block);
            break;
        }
      }
    }
  }

  void _spawningObjects() {

    //HealthIndicator healthIndicator = HealthIndicator();

    //add(healthIndicator);

    //add(healthIndicator);

    final spawnPointsLayer =
        levelTiledComponent.tileMap.getLayer<ObjectGroup>('spawn');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'player':
            esfera = Ball(playerX: spawnPoint.x + 10, playerY: spawnPoint.y + 10);
            add(esfera);

            PlayerEffects effects = PlayerEffects();

            effects.position = Vector2(spawnPoint.x, spawnPoint.y) - Vector2.all(32);

            add(effects);

            effects.animation = effects.animationsList[PlayerEffectState.appearing];
            Future.delayed(Duration(milliseconds: 350), () {
              effects.animation = effects.animationsList[PlayerEffectState.nullState];
              player.setOpacity(1);
            });

            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.setOpacity(0);
            add(player);

            break;
          
          case 'robot':

            PlayerEffects effects = PlayerEffects();
            Robot robot = Robot();

            effects.position = Vector2(spawnPoint.x, spawnPoint.y) - Vector2.all(32);

            add(effects);

            effects.animation = effects.animationsList[PlayerEffectState.appearing];
            Future.delayed(Duration(milliseconds: 350), () {
              effects.animation = effects.animationsList[PlayerEffectState.nullState];
              robot.setOpacity(1);
            });

            robot.position = Vector2(spawnPoint.x, spawnPoint.y);
            robot.setOpacity(0);
            add(robot);

          break;
        }
        game.health.value = game.enemiesCount.value;
      }
    }
  }
}