import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flame/flame.dart';
import 'package:flutter_flame_game/screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  FlameAudio.play('Disparo.mp3', volume: 0);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
        brightness: Brightness.dark,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/Background/Blue.png', fit: BoxFit.fill,),
        backgroundColor: ThemeData.dark().colorScheme.background,
        splashTransition: SplashTransition.rotationTransition,
        animationDuration: const Duration(milliseconds: 1000),
        curve: Curves.decelerate,
        pageTransitionType: PageTransitionType.fade,
        duration: 1000,
        nextScreen: const MainMenu(),
      ),
    ),
  );
}
