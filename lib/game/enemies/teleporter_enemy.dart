import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/enemies/enemy.dart';

enum TeleporterEnemyState { appearing, desappearing }

class TeleporterEnemy extends Enemy {
  TeleporterEnemy(
      {required spawnPoint,
      required this.firstTarget,
      required this.secondTarget})
      : super(spawnPoint) {
    // Initialize Robot-specific properties here
  }

  final Vector2 firstTarget;
  final Vector2 secondTarget;

  late final SpriteAnimation appearAnimation;
  late final SpriteAnimation dessaperAnimation;

  //10. Not necesary to override but it's here for reference purposes, the default value is true
  @override
  void spawnEffects(bool enabled) {
    super.spawnEffects(true);
  }

  @override
  onLoad() async {
    //print('El primer target es: $firstTarget');
    //print('El segundo target es: $secondTarget');

    character = 'Ghost';
    lifePoints = 2;

    //_spawnRobot();

    return super.onLoad();
  }

  @override
  void update(double dt) {

    if (position == spawnPoint) {
      
      Future.delayed(const Duration(seconds: 2), () {
        position = firstTarget;
        
      });

    } else if (position == firstTarget) {
      Future.delayed(const Duration(seconds: 2), () {
        position = secondTarget;
      });

    } else if (position == secondTarget) {
      Future.delayed(const Duration(seconds: 2), () {
        position = spawnPoint;
      });

    }

    super.update(dt);
  }


  @override
  loadAnimations() {
    idleAnimation = spriteAnimation('Idle', 10);
    hitAnimation = spriteAnimation('Hit', 5)..loop = false;
    dessaperAnimation = spriteAnimation('Desappear', 4)..loop = false;
    appearAnimation = spriteAnimation('Appear', 4)..loop = false;

    animationsList = {
      EnemyState.idle: idleAnimation,
      EnemyState.hit: hitAnimation,
      TeleporterEnemyState.appearing: appearAnimation,
      TeleporterEnemyState.desappearing: dessaperAnimation,
    };

    animation = animationsList[EnemyState.idle];
  }

  @override
  SpriteAnimation spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/$character/$state (44x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(44, 32),
      ),
    );
  }

  //Specific Robot methods here
}
