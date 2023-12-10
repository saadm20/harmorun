import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart'show FlameAudio;
import 'package:flutter/services.dart';
import 'package:harmorun_game/components/checkpoint.dart';
import 'package:harmorun_game/components/custom_components/custom-rectangle-collision.dart';
import 'package:harmorun_game/components/custom_components/custom_collisionBlock.dart';
import 'package:harmorun_game/components/custom_components/custom_hitbox.dart';
import 'package:harmorun_game/components/custom_components/custom_sprite_animation.dart';
import 'package:harmorun_game/components/fire.dart';
import 'package:harmorun_game/components/reward.dart';
import 'package:harmorun_game/components/rock.dart';
import 'package:harmorun_game/components/saw.dart';
import 'package:harmorun_game/core/constants/num_constants.dart';
import 'package:harmorun_game/core/constants/string_constants.dart';
import 'package:harmorun_game/core/enums/enums.dart';
import 'package:harmorun_game/harmorun.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<Harmorun>, KeyboardHandler, CollisionCallbacks {
  final String character;
  final VoidCallback? onLevelCompleted;
  Player({
    this.character = StringConstants.playerFolder,
this.onLevelCompleted,
    position,
  }) : super(
          position: position,
        );
  final double stepTime = NumConstants.stepTime;
  final double _gravity = NumConstants.gravity;
  final double _jumpForce = NumConstants.jumpForce;
  final double _terminalVelocity = NumConstants.terminalVelocity;

  double moveSpeed = NumConstants.moveSpeed;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = true;

  bool gotHit = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];
  double horizontalMovement = 0;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;
  bool hasJumped = false;
  @override
  FutureOr<void> onLoad() {
    priority=3;
    _loadAllAnimations();
    startingPosition = Vector2(position.x, position.y);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  void _loadAllAnimations() {
    final cs = CustomSpriteAnimation(
      game,
      stepTime,
    );
    idleAnimation = cs.animation(
      StringConstants.playerIdle,
      4,
    );
    runningAnimation = cs.animation(
      StringConstants.playerRun,
      6,
    );
    jumpingAnimation = cs.animation(
      StringConstants.playerJump,
      8,
    );
    fallingAnimation = cs.animation(
      StringConstants.playerIdle,
      4,
    );
    hitAnimation = cs.animation(
      StringConstants.playerDeath,
      8,
    );
    appearingAnimation = cs.animation(
      StringConstants.playerAppearing,
      7,
      loop: false,
      textureSize: 96,
    );
    disappearingAnimation = cs.animation(
      StringConstants.playerDesappearing,
      7,
      loop: false,
      textureSize: 96,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    current = PlayerState.idle;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    if (velocity.y > 0) playerState = PlayerState.idle;

    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Reward) other.collidedWithPlayer();
      if (other is Saw) {
     
        _respawn();
      }
      ;
      if (other is Fire) {
     
        _respawn();
      }
      ;
     if (other is Rock) other.collidedWithPlayer();
      if (other is Checkpoint) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped == true && isOnGround == true) {
      _playerJump(dt);
    }

    if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _respawn() async {
     if (game.playSounds) FlameAudio.play('appear.wav', volume: game.soundVolume);
    const canMoveDuration = Duration(milliseconds: 400);
    const respawnDuration = Duration(milliseconds: 800);
    gotHit = true;
    current = PlayerState.hit;


    Future.delayed(respawnDuration,()async{
         scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
    });

 
  }

  void _reachedCheckpoint() async {
    reachedCheckpoint = true;
    if (game.playSounds) {
     FlameAudio.play('finish.wav', volume: game.soundVolume);
    }
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    const waitToChangeDuration = Duration(seconds: 1);
    Future.delayed(waitToChangeDuration, () =>game.startNextLevel());
  }



    void collidedwithEnemy() {
    _respawn();
  }
}
