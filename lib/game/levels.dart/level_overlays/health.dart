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
    //var healthImage = 1;

    return Padding(
      padding: EdgeInsets.all(40),
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
                    gameRef.healthImage.value++;
                  }

                  double porcentaje = 0;

                  if (enemiesCount != 0) {
                    porcentaje = gameRef.healthImage.value / enemiesCount;
                    //porcentaje = enemiesKilled / enemiesCount;
                    porcentaje = porcentaje > 1 ? 1 : porcentaje;
                    
                  }

                  print('porcentaje: $porcentaje');

                  if (porcentaje < 0) {
                    gameRef.healthImage.value = 0;
                  }

                  return Stack(
                    children: [
                      LinearProgressIndicator(
                        value: porcentaje,
                        color: Color.fromARGB(255, 0, 255, 157),
                      ),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: Container(On
                      //       child: Image.asset(
                      //     'assets/images/HUD/Health/${gameRef.healthImage.value}.png',
                      //     fit: BoxFit.contain,
                      //     height: 40,
                      //   )),
                      // ),
                      Text(
                        'ENEMIGOS $enemiesKilled / $enemiesCount',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
