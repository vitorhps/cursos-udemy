import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  VideoPlayerController _videoPlayerController;

  _play() {
    /* _videoPlayerController = VideoPlayerController.network(
      "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"
    )..initialize().then((_) {
      setState(() {
        _videoPlayerController.play();
      });
    }); */

    _videoPlayerController = VideoPlayerController.asset(
      "videos/exemplo.mp4",
    )
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          // _videoPlayerController.play();
        });
      });
  }

  @override
  void initState() {
    super.initState();
    
    _play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _videoPlayerController.value.initialized
          ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          )
          : Text("Pressione Play"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          _videoPlayerController.value.isPlaying
            ? Icons.pause
            : Icons.play_arrow
        ),
        onPressed: () {
          setState(() {
            _videoPlayerController.value.isPlaying
              ? _videoPlayerController.pause()
              : _videoPlayerController.play();
          });
        },
      ),
    );
  }
}
