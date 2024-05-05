import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';

import 'dart:math' as math;

const gameColors = [
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.yellowAccent
];

class CircleRotator extends PositionComponent {
  CircleRotator({
    required super.position,
    required super.size,
    this.thickness = 8,
    this.rotationSpeed = 2,
  }) : super(anchor: Anchor.center);

  final double thickness;
  final double rotationSpeed;

  @override
  void onLoad() {
    super.onLoad();

    const circle = math.pi * 2;
    final sweep = circle / gameColors.length;
    for (int i = 0; i < gameColors.length; i++) {
      add(CircleArc(
        color: gameColors[i],
        startAngle: i * sweep,
        sweepAngle: sweep,
      ));
    }
    add(RotateEffect.to(
      math.pi * 2,
      EffectController(
        speed: rotationSpeed,
        infinite: true,
      ),
    ));
  }
}

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  CircleArc({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  }) : super(anchor: Anchor.center);

  Color getColor() {
    return color;
  }

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;
    _addHitbox();
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );
  }


  void _addHitbox() {
    final center = size / 2;
    const precision = 8;
    final segment = sweepAngle / (precision - 1);
    final radius = size.x / 2;

    List<Vector2> vertices = [];
    for (int i = 0; i < precision; i++) {
      final thisSegment = startAngle + segment * i;
      vertices.add(
        center + Vector2(math.cos(thisSegment), math.sin(thisSegment)) * radius,
      );
    }

    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = startAngle + segment * i;
      vertices.add(
        center +
            Vector2(math.cos(thisSegment), math.sin(thisSegment)) *
                (radius - parent.thickness),
      );
    }
    add(PolygonHitbox(
      vertices,
      collisionType: CollisionType.passive,
    ));
  }
}

class ColorSwitcher extends PositionComponent {
  final Vector2 sizeColorSwitcher;
  final Vector2 positionColorSwitcher;

  ColorSwitcher(
      {required this.sizeColorSwitcher, required this.positionColorSwitcher});

  @override
  void onMount() {
    size = sizeColorSwitcher;
    position = positionColorSwitcher;
    super.onMount();
  }

  @override
  void onLoad() {
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    final totalColorsLength = gameColors.length;
    final sweepAngle = (math.pi * 2) / totalColorsLength;
    for (int i = 0; i < totalColorsLength; i++) {
      canvas.drawArc(size.toRect(), i * sweepAngle, sweepAngle, true,
          Paint()..color = gameColors[i]);
    }
  }
}
