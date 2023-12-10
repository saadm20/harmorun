import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:harmorun_game/harmorun.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  //Harmorun game = Harmorun();
  runApp(
    const GameWidget.controlled(gameFactory: Harmorun.new),
  );
}

