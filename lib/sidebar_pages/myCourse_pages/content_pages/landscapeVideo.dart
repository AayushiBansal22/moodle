import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LandscapeVideo extends StatefulWidget {
  final String url;
  LandscapeVideo({required this.url});

  @override
  _LandscapeVideoState createState() => _LandscapeVideoState();
}

class _LandscapeVideoState extends State<LandscapeVideo> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isVideoClicked = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(_videoListener);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  double min(double a, double b) {
    return a < b ? a : b;
  }

  void _videoListener() {
    if (_controller.value.isPlaying) {
      setState(() {
        _sliderValue = min(
          _controller.value.position.inSeconds.toDouble(),
          _controller.value.duration.inSeconds.toDouble(),
        );
      });
    }
  }

  String formatDuration(Duration position) {
    final int hours = position.inHours;
    final int minutes = position.inMinutes % 60;
    final int seconds = position.inSeconds % 60;
    if (hours == 0 && seconds < 10) {
      return "$minutes:0$seconds";
    }
    else if (hours == 0) {
      return "$minutes:$seconds";
    }
    else if (seconds < 10) {
      return "$hours:$minutes:0$seconds";
    }
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVideoClicked = !_isVideoClicked;
        });
      },
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.001,
                  ),
                  child: (_controller.value.isInitialized)
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.999,
                          height: MediaQuery.of(context).size.height,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                      )
                      : Container(),
                ),
                if (_isVideoClicked)
                  ...[
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Slider(
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        value: _sliderValue,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        onChanged: (newValue) {
                          setState(() {
                            _sliderValue = newValue;
                            _controller.seekTo(Duration(seconds: newValue.toInt()));
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _controller.seekTo(_controller.value.position - Duration(seconds: 10));
                            },
                            child: Icon(Icons.fast_rewind),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                                _isPlaying = false;
                              } else {
                                _controller.play();
                                _isPlaying = true;
                              }
                              setState(() {});
                            },
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _controller.seekTo(_controller.value.position + Duration(seconds: 10));
                            },
                            child: Icon(Icons.fast_forward),
                          ),
                          Text(
                            formatDuration(_controller.value.position),
                            style: const TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.fullscreen_exit),
                          ),
                        ],
                      ),
                    ),
                  ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }
}