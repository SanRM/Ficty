import 'package:flame/components.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

enum EffectState {
  nullState,
  appearing,
}

class Effects extends SpriteAnimationComponent with HasGameRef<RobotsGame> {
  late final SpriteAnimation appearingAnimation;
  late final Map animationsList;
  final double stepTime = 0.05;

  @override
  onLoad() async {
    _loadAnimations();

    return super.onLoad();
  }

  _loadAnimations() {
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);

    animationsList = {
      EffectState.appearing: appearingAnimation,
      EffectState.nullState: null,
    };

    animation = animationsList[EffectState.nullState];
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
