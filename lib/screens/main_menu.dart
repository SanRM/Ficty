import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_game/screens/chaper_selection.dart';
import 'package:flutter_flame_game/screens/character_selection.dart';
import 'package:flutter_flame_game/utils/responsive.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final double responsiveHeight = Responsive(context: context).responsiveHeight;
    final double responsiveWidth = Responsive(context: context).responsiveWidth;

    final Map<String, List<dynamic>> principalMenu = {
      'Campaña': [const ChapterSelection(), Colors.purple[400], Icons.play_arrow_rounded],
      'Seleccionar aspecto': [const CharacterSelection(), Colors.cyan[400], Icons.person],
      'Tienda': [const CharacterSelection(), Colors.greenAccent[400], Icons.shopping_cart],
      'Configuración': [const CharacterSelection(), Colors.orange[400], Icons.settings],
      'Salir': [const CharacterSelection(), Colors.pink[400], Icons.exit_to_app],
    };

    menuButton({required String title, required Widget destiny, required Color color, required IconData icon}) {
      return Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => destiny,
              ),
            );
          },
          child: Container(
            alignment: Alignment.center,
            width: responsiveWidth / 4,
            margin: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: responsiveHeight / 4),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsiveHeight / 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 20, vertical: responsiveHeight / 10),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'JUEGO DE ROBOTS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveHeight / 10,
                        ),
                      ),
                      SizedBox(height: responsiveHeight / 20),
                      CarouselSlider(
                        options: CarouselOptions(height: responsiveHeight / 2.2, enlargeCenterPage: true, viewportFraction: 0.32),
                        items: principalMenu.entries.map((entry) {
                            return Builder(
                              builder: (BuildContext context) {
                                return menuButton(
                                  title: entry.key,
                                  destiny: entry.value[0],
                                  color: entry.value[1],
                                  icon: entry.value[2],
                                );
                              },
                            );
                          }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
