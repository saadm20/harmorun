import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:harmorun_game/components/custom_components/custom_hitbox.dart';
import 'package:harmorun_game/core/constants/string_constants.dart';
import 'package:harmorun_game/harmorun.dart';

class Fire extends SpriteAnimationComponent
    with HasGameRef<Harmorun>, CollisionCallbacks {
  Fire({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 14,
    width: 16,
    height: 30,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {

    priority = 1;

    add(
      RectangleHitbox(
        position: Vector2(
          hitbox.offsetX,
          hitbox.offsetY,
        ),
        size: Vector2(
          hitbox.width,
          hitbox.height,
        ),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(StringConstants.fire),
      SpriteAnimationData.sequenced(
        amount: 54 ,
        amountPerRow: 9,
        stepTime: stepTime,
        textureSize: Vector2(16,48),
      ),
    );
    return super.onLoad();
  }

  // void collidedWithPlayer() async {
  //   if (!collected) {
  //     collected = true;
  //     if (game.playSounds) {
  //       //  FlameAudio.play('collect_Fire.wav', volume: game.soundVolume);
  //     }
  //     animation = SpriteAnimation.fromFrameData(
  //       game.images.fromCache(StringConstants.),
  //       SpriteAnimationData.sequenced(
  //         amount: 6,
  //         stepTime: stepTime,
  //         textureSize: Vector2.all(32),
  //         loop: false,
  //       ),
  //     );

  //     await animationTicker?.completed;
  //     removeFromParent();
  //   }
  // }
}
