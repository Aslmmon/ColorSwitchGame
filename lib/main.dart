import 'package:colorswitch/game/ColorSwitchGame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ColorSwitchGame _game;

  @override
  void initState() {
    _game = ColorSwitchGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (_game.isGamePaused) {
                    _game.resumeGame();
                  } else {
                    _game.pauseGame();
                  }
                });
              },
              icon: Icon(
                  _game.isGamePaused ? Icons.pause_circle : Icons.play_circle),
            ),
          ),
          if (_game.isGamePaused)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Paused",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(
                      Icons.play_circle,
                      size: 42,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _game.resumeGame();
                      });
                    },
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
