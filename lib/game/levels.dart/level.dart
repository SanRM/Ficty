// level.dart

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/enemies/drone_enemy.dart';
import 'package:flutter_flame_game/game/enemies/robot_enemy.dart';
import 'package:flutter_flame_game/game/enemies/shield_bearer_enemy.dart';
import 'package:flutter_flame_game/game/enemies/teleporter_enemy.dart';
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
  bool dragIsOnCenter = true;
  Vector2 droneDestino = Vector2.zero();
  bool pointing = false;
  //AudioPlayer? audioPlayer;
  int? activePointerId;

  @override
  onLoad() async {
    //print('Loading map...');

    Future.delayed(const Duration(seconds: 1), () {
      game.isGameplayActive.value = true;
      //print('Gameplay active');
    });

    levelTiledComponent = await TiledComponent.load(
        '$levelName.tmx', prefix: 'assets/tiles/$chapter/', Vector2.all(16));

    add(levelTiledComponent);

    _spawningObjects();

    _currentPosition =
        Offset(game.target.value.x + 10, game.target.value.y + 10);
    //_currentPosition = Offset(game.target.value.x, game.target.value.y);

    _addCollisions();

    //print('Map loaded successfully');

    return super.onLoad();
  }

  @override
  void onDragStart(DragStartEvent event) {
    pointing = true;

    //ignorar este evento si ya hay un dedo activo
    if (activePointerId != null) {
      return;
    }

    //Guardar el id del dedo activo (pointerId)
    activePointerId = event.pointerId;

    if (pointing && game.playSounds.value && game.isGameplayActive.value) {
      playAudio();
    }

    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (game.isGameplayActive.value) {
      game.esfera.value.hitbox.collisionType = CollisionType.inactive;
      dragIsOnCenter = true;
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
      } else if (game.isGameplayActive.value) {
        //game.isGameplayActive.value = true;
        dragIsOnCenter = false;
        //pointing = false;

        stopAudio();

        double scale = radius * distance;
        newPosition = Offset(
            player.center[0] - (newPosition.dx + player.center[0]) / scale,
            player.center[1] - (newPosition.dy + player.center[1]) / scale);
      }

      _currentPosition = newPosition;

      //print(_currentPosition);
    } else {
      stopAudio();
    }

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {

    //ignorar este evento si el dedo activo inicial no es el que se levanta
    if (event.pointerId != activePointerId) {
      return;
    }

    //En caso contrario, limpiar el id del dedo activo
    activePointerId = null;

    //proceder con el evento
    if (game.isGameplayActive.value && dragIsOnCenter) {
      game.isGameplayActive.value = false;
      stopAudio();

      game.playSounds.value
          ? FlameAudio.play('Disparo.mp3', volume: game.soundVolume.value)
          : null;

      pointing = false;

      Future.delayed(const Duration(milliseconds: 100), () {
        game.esfera.value.hitbox.collisionType = CollisionType.active;
      });

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
    if (game.isGameplayActive.value && pointing) {
      final paint = Paint()
        ..color = Colors.pink
        ..strokeWidth = 2.0;

      Future.delayed(const Duration(seconds: 1), () {
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

          case 'player':
            game.esfera.value =
                Ball(playerX: spawnPoint.x + 10, playerY: spawnPoint.y + 10);
            add(game.esfera.value);

            player.position = Vector2(spawnPoint.x, spawnPoint.y);

            add(player);

            break;

          case 'robot':
            RobotEnemy robot = RobotEnemy(
                spawnPoint: Vector2(spawnPoint.x, spawnPoint.y - 11));
            add(robot);

            break;

          case 'shieldBearer':
            ShieldBearer shieldBearer =
                ShieldBearer(spawnPoint: Vector2(spawnPoint.x, spawnPoint.y));
            add(shieldBearer);

            break;

          case 'drone':
            var targetObjectId = spawnPoint.properties.first.value;
            var target = spawnPointsLayer.objects
                .firstWhere((element) => element.id == targetObjectId);

            DroneEnemy drone = DroneEnemy(
              spawnPoint: Vector2(spawnPoint.x, spawnPoint.y),
              target: Vector2(target.x, target.y),
            );

            add(drone);

            break;

          case 'teleporter':
            var firstTargetobjectid = spawnPoint.properties.first.value;
            var firstTarget = spawnPointsLayer.objects
                .firstWhere((element) => element.id == firstTargetobjectid);
            var firstVectorTarget = Vector2(firstTarget.x, firstTarget.y);

            var secondTargetobjectid = firstTarget.properties.first.value;
            var secondTarget = spawnPointsLayer.objects
                .firstWhere((element) => element.id == secondTargetobjectid);
            var secondVectorTarget = Vector2(secondTarget.x, secondTarget.y);

            TeleporterEnemy teleporter = TeleporterEnemy(
              spawnPoint: Vector2(spawnPoint.x - 7, spawnPoint.y + 4),
              firstTarget: firstVectorTarget,
              secondTarget: secondVectorTarget,
            );

            add(teleporter);

            break;
        }

        Future.delayed(const Duration(microseconds: 2), () {
          game.health.value = game.enemiesCount.value;
        });
      }
    }
  }

  Future<void> stopAudio() async {
    try {
      await gameRef.audioPlayer.value.pause();
      print('Audio player: ${gameRef.audioPlayer.value.state}');
    } catch (e) {
      print('Error occurred stopping audio player: $e');
    }
  }

  Future<void> playAudio() async {
    try {
      //await game.audioPlayer.value.play(AssetSource('audio/Apuntando_arma.mp3'), volume: game.soundVolume.value, mode: PlayerMode.lowLatency);
      gameRef.audioPlayer.value = await FlameAudio.loop('Apuntando_arma.mp3',
          volume: game.soundVolume.value);

      print('index of audio player: ${gameRef.audioPlayer.value.state.index}');

      if (gameRef.audioPlayer.value.state.index == 3) {}

      print('Audio player: ${gameRef.audioPlayer.value.state}');
    } catch (e) {}
  }
}
