import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:harmorun_game/core/constants/num_constants.dart';
class CustomSpriteAnimation {
  final Game game;
  final double stepTime;

  CustomSpriteAnimation(
    this.game,
    this.stepTime,
  );

  animation(
    fileName,
    amount, {
    loop = true,
    textureSize = NumConstants.defualtSize,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(fileName),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(textureSize),
        loop: loop,
      ),
    );
  }
}
