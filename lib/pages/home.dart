import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, bool> scores = {};
  final Map<String, Color> choices = {
    '🍎': Colors.red,
    '🥒': Colors.green,
    '🔵': Colors.blue,
    '🍋': Colors.yellow,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
  };
  int index = 0;

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("sound.wav");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Scores'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: choices.keys.map((elm) {
              return Expanded(
                child: Draggable<String>(
                    data: elm,
                    child: Movable(scores[elm] == true ? '✔️' : elm),
                    feedback: Movable(elm), //shape when drag
                    childWhenDragging: Movable(elm) // their place when drag
                    ),
              );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((element) {
              return buildTarget(element);
            }).toList()
              ..shuffle(Random(index)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            scores.clear();
            index++;
          });
        },
      ),
    );
  }

  Widget buildTarget(element) {
    return DragTarget<String>(
      builder: (context, _, __) {
        if (scores[element] == true) {
          return Container(
            color: Colors.white,
            child: Text('Bravo!'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[element],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == element,
      onAccept: (data) {
        setState(() {
          scores[element] = true;
          playLocalAsset();
        });
      },
      onLeave: (data) {},
    );
  }
}

class Movable extends StatelessWidget {
  final String emoji;
  Movable(this.emoji);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 100,
        padding: EdgeInsets.all(15),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}
