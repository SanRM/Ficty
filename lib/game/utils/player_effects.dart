import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

enum PlayerEffectState {
  nullState,
  appearing,
  desappearing
}

class PlayerEffects extends SpriteAnimationComponent with HasGameRef<RobotsGame> {
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation desappearingAnimation;
  late final Map animationsList;
  final double stepTime = 0.05;

  @override
  onLoad() async {
    _loadAnimations();

    return super.onLoad();
  }

  _loadAnimations() {
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    desappearingAnimation = _specialSpriteAnimation('Desappearing', 7);

    animationsList = {
      PlayerEffectState.appearing: appearingAnimation,
      PlayerEffectState.desappearing: desappearingAnimation,
      PlayerEffectState.nullState: null,
    };

    animation = animationsList[PlayerEffectState.nullState];
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
}
