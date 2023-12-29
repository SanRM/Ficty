import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/levels.dart/level_overlays/pause_button.dart';
import 'package:flutter_flame_game/game/robots_game.dart';
import 'package:flutter_flame_game/screens/main_menu.dart';
import 'package:flutter_flame_game/utils/responsive.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final RobotsGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double responsiveHeight =
        Responsive(context: context).responsiveHeight;
    final double responsiveWidth = Responsive(context: context).responsiveWidth;

    return Center(
      child: Container(
        width: responsiveWidth / 2,
        height: responsiveHeight / 1.5,
        padding: const EdgeInsets.symmetric(),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Juego pausado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveHeight / 10,
                ),
              ),
              SizedBox(
                width: responsiveWidth / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: responsiveHeight / 20),
                    FilledButton.tonal(
                      onPressed: () {
                        gameRef.resumeEngine();
                        gameRef.overlays.remove(PauseMenu.id);
                        gameRef.overlays.add(PauseButton.id);
                      },
                      child: const Text('Continuar'),
                    ),
                    SizedBox(height: responsiveHeight / 20),
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainMenu(),
                          ),
                        );
                      },
                      child: const Text('Menú principal'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
