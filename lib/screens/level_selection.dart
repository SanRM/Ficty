import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/levels.dart/level_overlays/history_panel.dart';
import 'package:flutter_flame_game/game/levels.dart/level_overlays/pause_button.dart';
import 'package:flutter_flame_game/game/levels.dart/level_overlays/pause_manu.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

class LevelSelection extends StatelessWidget {
  final String chapter;
  final int numberOfLevels;

  const LevelSelection({
    super.key,
    this.chapter = 'chapter-1',
    required this.numberOfLevels,
  });

  @override
  Widget build(BuildContext context) {
    double responsiveHeight = MediaQuery.of(context).size.height;
    double responsiveWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un nivel'),
      ),
      body: Container(
        margin: const EdgeInsets.all(40),
        //color: Colors.red,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 50,
          ),
          itemCount: numberOfLevels,
          itemBuilder: (context, index) {
            return FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GameWidget(
                      backgroundBuilder: (context) {
                        return Container(
                          color: Theme.of(context).colorScheme.background,
                        );
                      },
                      game: RobotsGame(
                        chapter: chapter,
                        levelName: 'level-${index + 1}',
                        responsiveWidth: responsiveWidth,
                        responsiveHeight: responsiveHeight,
                      ),
                      // loadingBuilder: (p0) {
                      //   return AnimatedSplashScreen(
                      //     splash: Image.asset(
                      //       'assets/images/Background/Blue.png',
                      //       fit: BoxFit.fill,
                      //     ),
                      //     backgroundColor: ThemeData.dark().colorScheme.background,
                      //     splashTransition: SplashTransition.rotationTransition,
                      //     animationDuration: const Duration(milliseconds: 1000),
                      //     curve: Curves.decelerate,
                      //     duration: 1000,
                      //     nextScreen: Container(),
                      //   );
                      // },
                      initialActiveOverlays: const [
                        //1. TODO: Agregar overlay de panel de historial
                        //HistoryPanel.id,
                        PauseButton.id,
                      ],
                      overlayBuilderMap: {
                        HistoryPanel.id:
                            (BuildContext context, RobotsGame gameRef) =>
                                HistoryPanel(gameRef: gameRef),
                        PauseButton.id:
                            (BuildContext context, RobotsGame gameRef) =>
                                PauseButton(gameRef: gameRef),
                        PauseMenu.id:
                            (BuildContext context, RobotsGame gameRef) =>
                                PauseMenu(gameRef: gameRef),
                      },
                    ),
                  ),
                );
              },
              child: Text('Nivel ${index + 1}'),
            );
          },
        ),
      ),
    );
  }
}
