import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flame/flame.dart';
import 'package:flutter_flame_game/screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await Flame.images.loadAll;

  runApp(
    MaterialApp(
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
