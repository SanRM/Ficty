
import 'package:flutter/material.dart';

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un personaje'),
      ),
      body: Container(
        margin: const EdgeInsets.all(40),
        color: Colors.red,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.blue,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(20),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}