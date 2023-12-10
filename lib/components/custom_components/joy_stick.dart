import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:harmorun_game/core/constants/num_constants.dart';
import 'package:harmorun_game/core/constants/string_constants.dart';

customJoyStick(images) {
  return JoystickComponent(
    priority: 2,
    background: SpriteComponent(
      sprite: Sprite(
        images.fromCache(StringConstants.joystickPath),
      ),
    ),
    knob: SpriteComponent(
      sprite: Sprite(
        images.fromCache(StringConstants.joystickKnobPath),
      ),
    ),
    margin: const EdgeInsets.only(
      left: NumConstants.defualtSize,
      bottom: NumConstants.defualtSize,
    ),
  );
}
