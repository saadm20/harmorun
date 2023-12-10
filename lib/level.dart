import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:harmorun_game/components/background.dart';
import 'package:harmorun_game/components/checkpoint.dart';
import 'package:harmorun_game/components/custom_components/custom_collisionBlock.dart';
import 'package:harmorun_game/components/fire.dart';
import 'package:harmorun_game/components/level_name.dart';
import 'package:harmorun_game/components/reward.dart';
import 'package:harmorun_game/components/rock.dart';
import 'package:harmorun_game/components/saw.dart';
import 'package:harmorun_game/core/constants/num_constants.dart';
import 'package:harmorun_game/core/constants/string_constants.dart';
import 'package:harmorun_game/harmorun.dart';
import 'package:harmorun_game/player.dart';

class Level extends World with HasGameRef<Harmorun> {
  final Player player;
  final String levelName;
  Level(
    this.player,
    this.levelName,
  );
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      levelName,
      Vector2.all(
        NumConstants.defualtSize / 2,
      ),
    );
    _spawningObjects();
//_background()
    add(level);
    _addCollisions();

    return super.onLoad();
  }

  void _background() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundTile = BackgroundTile(

        position: Vector2(0, 0),
      );
      add(backgroundTile);
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(
      StringConstants.spawnpointsLayer,
    );

    if (spawnPointsLayer != null) {
      for (final sp in spawnPointsLayer.objects) {
        switch (sp.class_) {
          case StringConstants.player:
            player.position = Vector2(sp.x, sp.y);
            player.scale.x = 1;
            add(player);
          case StringConstants.rewardString:
            final reward = Reward(
              position: Vector2(
                sp.x,
                sp.y,
              ),
              size: Vector2(
                sp.width,
                sp.height,
              ),
            );
            add(reward);
            break;
          case StringConstants.sawString:
            final isVertical = sp.properties.getValue('isVertical');
            final offNeg = sp.properties.getValue('offNeg');
            final offPos = sp.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height),
            );
            add(saw);
            break;
          case 'Level':
            final text = LevelName(
              Vector2(sp.x, sp.y),
              Vector2(
                sp.width,
                sp.height,
              ),
              game.currentLevel.toString(),
            );
            add(text);
            break;
          case 'Rock':
            print('a');
            final offNeg = sp.properties.getValue('offNeg');
            final offPos = sp.properties.getValue('offPos');
            final rock = Rock(
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height),
              offNeg: offNeg,
              offPos: offPos,
            );
            add(rock);
            break;

          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(sp.x, sp.y),
              size: Vector2(sp.width, sp.height),
            );
            add(checkpoint);
            break;
          case StringConstants.fireString:
            final fire = Fire(
                position: Vector2(sp.x, sp.y),
                size: Vector2(
                  sp.width,
                  sp.height,
                ));
            add(fire);
            break;
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer =
        level.tileMap.getLayer<ObjectGroup>(StringConstants.collisions);

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case StringConstants.platform:
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
