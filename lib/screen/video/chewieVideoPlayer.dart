import 'package:flutter/material.dart';
import 'package:set_academy/Utils/Color.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MyNewVideoPlayer extends StatelessWidget {
  const MyNewVideoPlayer({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return MyVideoPlayer(url: url);
  }
}

class MyVideoPlayer extends StatefulWidget {
  final String url;
  const MyVideoPlayer({super.key, required this.url});

  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

bool _isPlaying = false;

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  double _currentSpeed = 1.0; // سرعة التشغيل الحالية

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.url.toString());
    _chewieController = ChewieController(
      autoInitialize: true,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
      customControls: Builder(
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VideoProgressIndicator(
                          _videoPlayerController,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.red,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.black26,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  _chewieController.enterFullScreen();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.replay_10, // زر الرجوع 10 ثواني
                                color: Colors.white,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  final currentPosition = _videoPlayerController.value.position;
                                  final newPosition = currentPosition - Duration(seconds: 10);
                                  _videoPlayerController.seekTo(newPosition);
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.play();
                                  _isPlaying = true;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.pause();
                                  _isPlaying = false;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.forward_10, // زر التقديم 10 ثواني
                                color: Colors.white,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  final currentPosition = _videoPlayerController.value.position;
                                  final newPosition = currentPosition + Duration(seconds: 10);
                                  _videoPlayerController.seekTo(newPosition);
                                });
                              },
                            ),
                            PopupMenuButton<double>(
                              onSelected: (value) {
                                setState(() {
                                  _currentSpeed = value;
                                  _videoPlayerController.setPlaybackSpeed(value);
                                });
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0.5,
                                  child: Text("0.5x"),
                                ),
                                PopupMenuItem(
                                  value: 1.0,
                                  child: Text("1x (Normal)"),
                                ),
                                PopupMenuItem(
                                  value: 1.5,
                                  child: Text("1.5x"),
                                ),
                                PopupMenuItem(
                                  value: 2.0,
                                  child: Text("2x"),
                                ),
                              ],
                              child: Icon(
                                Icons.speed,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(Colorbutton),
        title: Text("video"),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
