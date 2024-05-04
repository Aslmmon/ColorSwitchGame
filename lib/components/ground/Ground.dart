import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  static const String keyName = "single_ground";

  Ground({required super.position})
      : super(
            size: Vector2(200, 2),
            anchor: Anchor.center,
            key: ComponentKey.named(keyName));

  late Sprite fingerSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    fingerSprite = await Sprite.load("finger.png");
  }

  @override
  void render(Canvas canvas) {
    // canvas.drawRect(
    //     Rect.fromLTWH(0, 0, width, height), Paint()..color = (Colors.red));
    fingerSprite.render(canvas,
        position: Vector2(55, 0), size: Vector2(100, 100));
  }
}
