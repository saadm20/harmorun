import 'dart:ui' show Color;

class StringConstants {
  static const Color backgroundColor = Color.fromARGB(
    255,
    181,
    234,
    255,
  );
  static const String splashScreenId = 'SplashScreen';
  static const String kaphFont = 'Kaph';
  static const String varinoFont = 'Varino';
  static const String collisions = 'Collisions';
  static const String platform = 'Platform';

  static const String spawnpointsLayer = 'Spawnpoints';
  static const String player = 'Player';
  static const String rewardString = 'Reward';
  static const String sawString = 'Saw';
  static const String fireString = 'Fire';
  static const String joystickKnobPath = 'Joystick/knob.png';
  static const String joystickPath = 'Joystick/joystick.png';
  static const String playerFolder = 'player';
  static const String playerAppearing = 'player/Appearing (96x96).png';
  static const String playerDesappearing = 'player/Desappearing (96x96).png';
  static const String playerDeath = 'player/player_Death_8.png';
  static const String playerHurt = 'player/player_Hurt_4.png';
  static const String playerIdle = 'player/player_Idle_4.png';
  static const String playerJump = 'player/player_Jump_8.png';
  static const String playerRun = 'player/player_Run_6.png';
  static const String playerImage = 'player/player.png';
  
  static const String reward = 'resources/Coin-16x16.png';
  static const String rewardCollected = 'resources/Collected.png';
  static const String sawOn = 'traps/saw/On (38x38).png';
  static const String fire = 'fire/fire.png';

  static final Map<int, String> levels = {
    1: 'Level-1.tmx',
    2: 'Level-2.tmx',
  };

  const StringConstants._();
}
