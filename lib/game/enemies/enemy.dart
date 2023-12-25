import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter_flame_game/game/player/ball.dart';
import 'package:flutter_flame_game/game/robots_game.dart';
import 'package:flutter_flame_game/game/utils/player_effects.dart';

enum EnemyState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
}

abstract class Enemy extends SpriteAnimationComponent
    with HasGameRef<RobotsGame>, CollisionCallbacks {
  Enemy() : super(size: Vector2.all(50.0));

  TextComponent lifePointsText = TextComponent();

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;

  late final Map animationsList;

  int lifePoints = 3;
  late int lifePointsCounter = 0;
  final double stepTime = 0.05;
  String character = 'Mask Dude';
  bool isActive = true;
  List<Ball> collidedBalls = [];
  double porcentaje = 0;

  // set character(String character) {
  //   _character = character;
  // }

  @override
  onLoad() async {
    lifePointsText = TextComponent(
        text: '$lifePoints',
        position: -Vector2(0, 10),
        scale: Vector2.all(0.5));

    _loadAnimations();
    _spawnRobot();

    lifePointsCounter = lifePoints;
    // print('lifePointsCounter: $lifePointsCounter');
    // print('lifePoints: $lifePoints');
    game.enemiesCount.value++;
    game.numberOfShots.value++;

    return super.onLoad();
  }

  _loadAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);

    animationsList = {
      EnemyState.idle: idleAnimation,
      EnemyState.running: runningAnimation,
      EnemyState.jumping: jumpingAnimation,
      EnemyState.falling: fallingAnimation,
      EnemyState.hit: hitAnimation,
      EnemyState.appearing: appearingAnimation,
    };

    animation = animationsList[EnemyState.idle];
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
      ),
    );
  }

  void _spawnRobot() {
    add(
      RectangleHitbox(collisionType: CollisionType.active),
    );

    animation = animationsList[EnemyState.idle];
  }

@override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball && !collidedBalls.contains(other)) {
      collidedBalls.add(other);
      lifePoints--;
      //print(lifePoints);
      animation = animationsList[EnemyState.hit];

      Future.delayed(Duration(milliseconds: 350), () {
        animation = animationsList[EnemyState.idle];
      });
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the progress bar
    canvas.drawRect(Rect.fromLTWH(10, -5, size.x / 1.5 * porcentaje, size.y / 20), Paint()..color = Color(0xFF00FF00));
    porcentaje <= 0 ? 0 : canvas.drawRect(Rect.fromLTWH(10, -5, size.x / 1.5 * 1, size.y / 20), Paint()..color = Color.fromARGB(71, 248, 248, 248));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isActive) {
      collidedBalls
          .removeWhere((ball) => !this.toRect().overlaps(ball.toRect()));

      lifePointsText.text = '$lifePoints';
      add(lifePointsText);

      porcentaje = lifePoints / lifePointsCounter;
      //print('porcentaje: $porcentaje');

      if (lifePoints == 0) {
        //print('Robot died');
        _die();
      }
    }
  }

  void _die() {
    isActive = false;

    gameRef.health.value = gameRef.health.value + 2;

    lifePointsText.text = '';
    lifePoints = 2;

    PlayerEffects effects = PlayerEffects();

    add(effects);

    effects.position = Vector2.all(0) - Vector2.all(32);

    effects.animation = effects.animationsList[PlayerEffectState.desappearing];

    Future.delayed(Duration(milliseconds: 350), () {
      effects.animation = effects.animationsList[PlayerEffectState.nullState];
      this.setOpacity(0);
    });

    game.enemiesKilled.value++;
  }

}
