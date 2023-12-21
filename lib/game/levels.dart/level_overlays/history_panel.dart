import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/levels.dart/level_overlays/health.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

class HistoryPanel extends StatelessWidget {
  static const String id = 'history_panel';
  final RobotsGame gameRef;

  const HistoryPanel({required this.gameRef, super.key});

  @override
  Widget build(BuildContext context) {

    gameRef.pauseEngine();

    double responsiveHeight = MediaQuery.of(context).size.height;
    double responsiveWidth = MediaQuery.of(context).size.width;

    //TODO: Pass the history panel images to the history panel widget

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsiveWidth / 20,
          vertical: responsiveHeight / 10,
        ),
        child: SizedBox(
          width: responsiveWidth,
          height: responsiveHeight,
          child: Card(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Paneles de historia',
                    style: TextStyle(
                      fontSize: responsiveHeight / 15,
                    ),
                  ),
                ),
                Positioned(
                  bottom: responsiveHeight / 15,
                  right: responsiveWidth / 25,
                  child: FilledButton(
                    onPressed: () {
                      gameRef.overlays.remove(HistoryPanel.id);
                      gameRef.resumeEngine();
                      //gameRef.overlays.add(HealthIndicator.id);
                    },
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
