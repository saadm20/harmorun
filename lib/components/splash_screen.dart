import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';

typedef Callback = Function(BuildContext buildContext);

class SplashScreenGame extends StatelessWidget {
  final Callback onFinish;
 const SplashScreenGame({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        controller: FlameSplashController(
          waitDuration:const  Duration(
            milliseconds: 2000,
          ),
          fadeInDuration: const Duration(
            milliseconds: 1000,
          ),
          fadeOutDuration: const Duration(
            milliseconds: 100,
          ),
        ),
        showBefore: (BuildContext context) {
          return Image.asset('images/logo.png');
        },
        showAfter: (BuildContext context) {
          return const CircularProgressIndicator(strokeWidth: 20,
strokeCap: StrokeCap.round,
          );
        },
        theme: FlameSplashTheme.white,
        onFinish: onFinish,
      ),
    );
  }
}
