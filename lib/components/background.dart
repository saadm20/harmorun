import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import 'package:flutter/painting.dart';

class BackgroundTile extends ParallaxComponent  {
  
  BackgroundTile({
    position,

  }):super(position: position);

@override
  FutureOr<void> onLoad()async {
    priority=-10;
    size=Vector2.all(64);
  parallax=await game.loadParallax([
    ParallaxImageData('background.jpg')
  ],
baseVelocity:Vector2(0,0),
repeat: ImageRepeat.noRepeat,
fill: LayerFill.width,

  );
    return super.onLoad();
  }


}