import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class LevelName extends TextComponent {
  final String text;
  LevelName(
    position,
    size,
    this.text,
  ) : super(
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() {
    final painter = TextPaint(
      style: const TextStyle(
        fontFamily: 'RaleWay',
        color: Color.fromARGB(255, 30, 54, 77),
        fontWeight: FontWeight.w700,
        fontSize: 30,
      ),
    );

  // text = text;
    textRenderer = painter;
    //  add(textComponent);
    return super.onLoad();
  }
}
