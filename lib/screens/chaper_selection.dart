import 'package:flutter/material.dart';
import 'package:flutter_flame_game/screens/level_selection.dart';

class ChapterSelection extends StatelessWidget {
  const ChapterSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<dynamic>> capitulos = {
      'Capítulo 1' : ['chapter-1', 3],
      'Capítulo 2' : ['chapter-2', 4],
      'Capítulo 3' : ['chapter-3', 5],
      'Capítulo 4' : ['chapter-4', 6],
      'Capítulo 5' : ['chapter-5', 7],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un capítulo'),
      ),
      body: Center(
        child: SizedBox(
          //margin: const EdgeInsets.all(40),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 1,
          //color: Colors.red,
          child: ListView.builder(
            itemCount: capitulos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height / 40),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LevelSelection(
                          chapter: 'chapter-${index + 1}',
                          numberOfLevels: capitulos.values.elementAt(index)[1],
                        ),
                      ),
                    );
                  },
                  child: Text(capitulos.keys.elementAt(index)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
