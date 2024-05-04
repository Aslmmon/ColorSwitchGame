import 'dart:ui';
import 'package:colorswitch/components/circleRotator/CircleRotator.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/ground/Ground.dart';
import '../components/player/PlayerBall.dart';


class ColorSwitchGame extends FlameGame with TapCallbacks {
  late PlayerBall playerBall;

  ColorSwitchGame()
      : super(
            camera:
                CameraComponent.withFixedResolution(width: 600, height: 1000));

  @override
  Color backgroundColor() {
    return Colors.black;
  }

  @override
  void onMount() {
    playerBall = PlayerBall(15);

    world.addAll([
      Ground(position: Vector2(0, 400)),
      playerBall,
      generateCircleRotator()
    ]);
    debugMode = true;
    super.onMount();
  }

  @override
  void update(double dt) {
    makeCameraFollowPlayerUpward();
    super.update(dt);
  }

  void makeCameraFollowPlayerUpward() {
    final cameraY = camera.viewfinder.position.y;
    final playerY = playerBall.position.y;
    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(0, playerBall.position.y);
    }
  }

  CircleRotator generateCircleRotator() {
    return CircleRotator(position: Vector2(0, 0), size: Vector2.all(200));
  }

  @override
  void onTapDown(TapDownEvent event) {
    playerBall.jump();
    super.onTapDown(event);
  }
}
