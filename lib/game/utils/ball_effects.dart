import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

enum BallEffectState {
  nullState,
  collision,
}

class BallEffects extends SpriteAnimationComponent with HasGameRef<RobotsGame> {


  BallEffects();

  late final SpriteAnimation collisionAnimation;
  late final Map animationsList;
  final double stepTime = 0.05;

  @override
  onLoad() async {
    
    _loadAnimations();

    return super.onLoad();
  }

  _loadAnimations() {
    collisionAnimation = _specialSpriteAnimation('Appearing', 7);

    animationsList = {
      BallEffectState.collision: collisionAnimation,
      BallEffectState.nullState: null,
    };

    animation = animationsList[BallEffectState.nullState];
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
  

}
