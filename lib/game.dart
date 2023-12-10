import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:harmorun_game/core/constants/num_constants.dart';
import 'package:harmorun_game/harmorun.dart';
import 'package:harmorun_game/level.dart';
import 'package:harmorun_game/player.dart';

class Gameplay extends Component with HasGameReference<Harmorun> {
  Gameplay(
    this.currentLevel, {
    super.key,
  });

  static const id = 'Gameplay';

  int currentLevel;

  late CameraComponent cam;
  late JoystickComponent joystick;
  Player player = Player();
  @override
  Future<void> onLoad() async {
    _loadLevel();
    FlameAudio.play('opener.wav', volume: game.soundVolume);
    return super.onLoad();
  }

  void _loadLevel() {
    Level world = Level(
      game.player,
      game.allLevels[currentLevel]!,
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: NumConstants.worldWidth,
      height: NumConstants.worldHeight,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
  }
}
