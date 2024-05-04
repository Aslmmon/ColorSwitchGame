import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

Vector2 speed = Vector2(0, 30.0);
const gravity = 500.0;
const jumpSpeed = 350.0;

Vector2 startPlayerPosition = Vector2.zero();

class PlayerBall extends PositionComponent {
  final double radius;

  PlayerBall(this.radius);

  @override
  void onMount() {
    position = startPlayerPosition;
    size = Vector2.all(radius * 2 );
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    position += speed * dt;
    speed.y += gravity * dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
        (size / 2).toOffset(), radius, Paint()..color = Colors.blue);
  }

  void jump() {
    speed.y = -jumpSpeed;
  }
}
