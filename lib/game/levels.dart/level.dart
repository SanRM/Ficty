// level.dart
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/enemies/drone_enemy.dart';
import 'package:flutter_flame_game/game/enemies/robot_enemy.dart';
import 'package:flutter_flame_game/game/enemies/shieldBearer_enemy.dart';
import 'package:flutter_flame_game/game/utils/collision_block.dart';
import 'package:flutter_flame_game/game/player/ball.dart';
import 'package:flutter_flame_game/game/player/player.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

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
  //late Ball esfera;
  late bool dragOnCenter;
  Vector2 droneDestino = Vector2.zero();

  @override
  onLoad() async {
    //print('Loading map...');

    Future.delayed(Duration(seconds: 1), () {
      game.isGameplayActive.value = true;
      //print('Gameplay active');
    });

    levelTiledComponent = await TiledComponent.load(
        '$levelName.tmx', prefix: 'assets/tiles/$chapter/', Vector2.all(16));

    add(levelTiledComponent);

    dragOnCenter = true;

    _spawningObjects();

    _currentPosition =
        Offset(game.target.value.x + 10, game.target.value.y + 10);
    //_currentPosition = Offset(game.target.value.x, game.target.value.y);

    _addCollisions();

    //print('Map loaded successfully');

    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (game.isGameplayActive.value == true) {
      dragOnCenter = true;
      game.esfera.value.resetBall;

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
        dragOnCenter = false;

        double scale = radius * distance;
        newPosition = Offset(
            player.center[0] - (newPosition.dx + player.center[0]) / scale,
            player.center[1] - (newPosition.dy + player.center[1]) / scale);
      }

      _currentPosition = newPosition;

      //print(_currentPosition);
    }

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (game.isGameplayActive.value && dragOnCenter) {
      game.esfera.value.velocity = Vector2(
        _currentPosition.dx - player.center[0],
        _currentPosition.dy - player.center[1],
      );

      game.esfera.value.paint.color = Colors.white;

      game.numberOfShots.value--;

      //print('velocity: ${esfera.velocity}');
    }

    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    if (game.isGameplayActive.value == true) {
      final paint = Paint()
        ..color = Colors.pink
        ..strokeWidth = 2.0;

      Future.delayed(Duration(seconds: 1), () {
        paint.color = Colors.transparent;
      });

      canvas.drawLine(
          Offset(player.center[0], player.center[1]), _currentPosition, paint);
    }

    super.render(canvas);
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

  void _spawningObjects() async {
    //HealthIndicator healthIndicator = HealthIndicator();

    //add(healthIndicator);

    //add(healthIndicator);

    final spawnPointsLayer =
        levelTiledComponent.tileMap.getLayer<ObjectGroup>('spawn');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'player target':
            //print('Player target detected at ${spawnPoint.x}, ${spawnPoint.y}');
            game.target.value = Vector2(spawnPoint.x, spawnPoint.y);

            break;

          case 'drone target':
            droneDestino = Vector2(spawnPoint.x, spawnPoint.y);
            //print('Drone target detected at ${droneDestino} in level.dart');

            break;

          case 'player':
            game.esfera.value = Ball(playerX: spawnPoint.x + 10, playerY: spawnPoint.y + 10);
            add(game.esfera.value);

            // PlayerEffects effects = PlayerEffects();

            // effects.position = game.target.value - Vector2.all(32);

            // add(effects);

            // effects.animation =
            //     effects.animationsList[PlayerEffectState.appearing];

            // Future.delayed(Duration(milliseconds: 350), () {
            //   effects.animation =
            //       effects.animationsList[PlayerEffectState.nullState];
            //   //player.setOpacity(1);
            // });

            player.position = Vector2(spawnPoint.x, spawnPoint.y);

            add(player);

            break;

          case 'robot':
            RobotEnemy robot = RobotEnemy(Vector2(spawnPoint.x, spawnPoint.y));
            add(robot);

            break;

          case 'shieldBearer':
            ShieldBearer shieldBearer =
                ShieldBearer(Vector2(spawnPoint.x, spawnPoint.y));
            add(shieldBearer);

            break;

          case 'drone':
            Future.delayed(
              Duration(microseconds: 1),
              () {
                if (droneDestino != Vector2.zero()) {
                  DroneEnemy drone = DroneEnemy(
                      spawnPoint: Vector2(spawnPoint.x, spawnPoint.y),
                      target: droneDestino);
                  add(drone);
                }
              },
            );

            break;
        }
        game.health.value = game.enemiesCount.value;
      }
    }
  }
}
