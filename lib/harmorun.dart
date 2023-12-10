import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:harmorun_game/components/custom_components/joy_stick.dart';
import 'package:harmorun_game/components/splash_screen.dart';
import 'package:harmorun_game/core/constants/num_constants.dart';
import 'package:harmorun_game/core/constants/string_constants.dart';
import 'package:harmorun_game/game.dart';
import 'package:harmorun_game/player.dart';

class Harmorun extends FlameGame
    with
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks,
        HasKeyboardHandlerComponents {
  late CameraComponent cam;
  late JoystickComponent joystick;
  Player player = Player();
  bool showJoystick = false;
  bool playSounds = true;
  double soundVolume = NumConstants.soundVolume;
  Map<int, String> allLevels = StringConstants.levels;
  int currentLevel = 1;

  bool shouldLoad = false;
  late final _routes = <String, Route>{
    StringConstants.splashScreenId: OverlayRoute(
      (context, game) => SplashScreenGame(
        onFinish: (context) {
          _startLevel(currentLevel);
        },
      ),
    ),
  };

  late final _router = RouterComponent(
    initialRoute: StringConstants.splashScreenId,
    routes: _routes,
  );

  void _routeById(String id) {
    _router.pushNamed(id);
  }

  @override
  Color backgroundColor() => StringConstants.backgroundColor;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await add(_router);

    if (showJoystick) {
      joystick = customJoyStick(images);
      add(joystick);
    }
    return super.onLoad();
  }

  void startNextLevel() {
    currentLevel = currentLevel + 1;
  
    var gameplay = findByKeyName<Gameplay>(Gameplay.id);

    if (gameplay != null) {
      if (gameplay.currentLevel >= allLevels.length) {
        _startLevel(1);
      } else {
        _startLevel(currentLevel);
      }
    }
  }

  void _startLevel(int levelIndex) {
    _router.pushReplacement(
      Route(
        () => Gameplay(
          levelIndex,
          key: ComponentKey.named(Gameplay.id),
        ),
      ),
      name: Gameplay.id,
    );
  }
}
