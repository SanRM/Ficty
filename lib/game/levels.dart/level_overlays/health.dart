// import 'package:flame/components.dart';
// import 'package:flutter_flame_game/game/robots_game.dart';

// class HealthIndicator extends SpriteAnimationComponent with HasGameRef<RobotsGame> {

//   double stepTime = 0.05;

//   @override
//   onLoad() async {

//     _loadAnimation;

//     return super.onLoad();
//   }

//   get _loadAnimation {

//     position = Vector2(40, 40);

//     animation = SpriteAnimation.fromFrameData(
//       game.images.fromCache('HUD/health.png'),
//       SpriteAnimationData.sequenced(
//         amount: 8,
//         stepTime: stepTime,
//         textureSize: Vector2.all(48),
//       ),
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:flutter_flame_game/game/robots_game.dart';

class HealthIndicator extends StatelessWidget {
  static const String id = 'HealthIndicator';
  final RobotsGame gameRef;

  const HealthIndicator({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    double porcentaje = 0;
    late Color linearProgressIndicatorColor;

    return Padding(
      padding: const EdgeInsets.all(40),
      child: ValueListenableBuilder(
        valueListenable: gameRef.enemiesKilled,
        builder: (context, enemiesKilled, child) {
          return ValueListenableBuilder(
            valueListenable: gameRef.numberOfShots,
            builder: (context, numberOfShots, child) {
              return ValueListenableBuilder(
                valueListenable: gameRef.enemiesCount,
                builder: (context, enemiesCount, child) {
                  //print('numberOfShots: $numberOfShots');

                  if (numberOfShots < enemiesCount) {
                    gameRef.health.value--;
                  }

                  if (enemiesCount != 0) {
                    porcentaje = gameRef.health.value / enemiesCount;
                    //porcentaje = enemiesKilled / enemiesCount;
                    porcentaje = porcentaje > 1 ? 1 : porcentaje;
                  }

                  gameRef.health.value = gameRef.health.value > enemiesCount
                      ? enemiesCount
                      : gameRef.health.value;

                  print('porcentaje: $porcentaje');
                  print('gameRef.health.value: ${gameRef.health.value}');

                  if (porcentaje < 0) {
                    gameRef.health.value = 0;
                  }

                  if (porcentaje >= 1) {
                    linearProgressIndicatorColor =
                        const Color.fromARGB(255, 0, 255, 42);
                  } else if (porcentaje > 0.8) {
                    linearProgressIndicatorColor =
                        const Color.fromARGB(255, 0, 255, 170);
                  } else if (porcentaje > 0.6) {
                    linearProgressIndicatorColor =
                        const Color.fromARGB(255, 166, 255, 0);
                  } else if (porcentaje > 0.4) {
                    linearProgressIndicatorColor =
                        const Color.fromARGB(255, 255, 255, 0);
                  } else if (porcentaje > 0.2) {
                    linearProgressIndicatorColor =
                        const Color.fromARGB(255, 255, 170, 0);
                  } else if (porcentaje >= 0) {
                    linearProgressIndicatorColor =
                        const Color.fromARGB(255, 255, 20, 79);
                  }

                  return Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 8,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: porcentaje,
                            color: linearProgressIndicatorColor,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width / 60)),
                          Text(
                            'ENEMIGOS $enemiesKilled/$enemiesCount',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 60,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Container(On
                  //       child: Image.asset(
                  //     'assets/images/HUD/Health/${gameRef.healthImage.value}.png',
                  //     fit: BoxFit.contain,
                  //     height: 40,
                  //   )),
                  // ),
                },
              );
            },
          );
        },
      ),
    );
  }
}
