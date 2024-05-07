import 'package:colorswitch/game/ColorSwitchGame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:colorswitch/components/circleRotator/CircleRotator.dart';

import '../ground/Ground.dart';
import '../star/StarComponent.dart';

Vector2 speed = Vector2(0, 30.0);
const gravity = 500.0;
const jumpSpeed = 350.0;

Vector2 startPlayerPosition = Vector2.zero();

class PlayerBall extends PositionComponent
    with HasGameRef<ColorSwitchGame>, CollisionCallbacks {
  final double radius;
  Color colorPlayer;

  PlayerBall(this.radius, this.colorPlayer);

  @override
  void onMount() {
    position = startPlayerPosition;
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void onLoad() {
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    position += speed * dt;
    speed.y += gravity * dt;

    Ground? ground = gameRef.findByKeyName(Ground.keyName);
    if (ground != null) {
      if (positionOfAnchor(Anchor.bottomCenter).y > ground.y) {
        position = Vector2(0, ground.position.y - (height / 2));
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
        (size / 2).toOffset(), radius, Paint()..color = colorPlayer);
  }

  void jump() {
    speed.y = -jumpSpeed;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ColorSwitcher) {
      other.removeFromParent();
      colorPlayer = Colors.redAccent;
      print(other);
    } else if (other is CircleArc) {
      if (colorPlayer != (other as CircleArc).getColor()) {
        // print("game over");
        print("game over");
        gameRef.gameOver();
      } else {
        print("Passed");
      }
      // print( "passed by "+  (other as CircleArc).getColor().value.toString());
      // print( "player color  "+  colorPlayer.value.toString());
    }
    else if (other is StarComponent) {
      other.showCollectEffect();
      gameRef.increaseScore();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {}
}
