import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache(prefix: "audios/");
  bool firstPlay = true;
  double volume = 0.5;

  _play() async {
    audioPlayer.setVolume(volume);

    if (firstPlay) {
      audioPlayer = await audioCache.play("musica.mp3");
      firstPlay = false;
    } else {
      audioPlayer.resume();
    }

    // String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3";
    // int result = await audioPlayer.play(url);
  }

  _pause() async {
    int result = await audioPlayer.pause();
  }

  _stop() async {
    int result = await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Executando Sons"),
      ),
      body: Column(
        children: <Widget>[
          Slider(
            value: volume,
            min: 0,
            max: 1,
            onChanged: (double value) {
              setState(() {
                volume = value;
              });
              audioPlayer.setVolume(volume);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  child: Image.asset("assets/images/executar.png"),
                  onTap: _play,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  child: Image.asset("assets/images/pausar.png"),
                  onTap: _pause,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  child: Image.asset("assets/images/parar.png"),
                  onTap: _stop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
