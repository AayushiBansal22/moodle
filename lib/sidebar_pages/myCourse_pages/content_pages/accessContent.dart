import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/content_pages/landscapeVideo.dart';

class AccessContent extends StatefulWidget {
  final String conTitle;
  final String? courseId;
  AccessContent({Key? key, required this.conTitle, required this.courseId}) : super(key: key);

  @override
  State<AccessContent> createState() => _AccessContentState();
}

class _AccessContentState extends State<AccessContent> {
  VideoPlayerController? _controller;
  String id = '';
  bool _isPlaying = false;
  bool _isVideoClicked = false;
  double _sliderValue = 0.0;

  Future<String> fetchVideoUrl() async {
    String? id = await widget.courseId;
    if (id != null) {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('courses').doc(id).collection('content')
          .where('conTitle', isEqualTo: widget.conTitle).get()
          .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.first;
      });
      return documentSnapshot['fileURL'];
    } else {
      throw Exception('courseId is null');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await fetchVideoUrl().then((url) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _controller!.initialize().then((_) {
        _controller!.addListener(_videoListener);
        setState(() {});
      });
    });
  }

  double min(double a, double b) {
    return a < b ? a : b;
  }

  void _videoListener() {
    if (_controller != null && _controller!.value.isPlaying) {
      setState(() {
        _sliderValue = min(
          _controller!.value.position.inSeconds.toDouble(),
          _controller!.value.duration.inSeconds.toDouble(),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: Text(
                      'Video Lecture',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.03,
                      right: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: (_controller != null && _controller!.value.isInitialized)
                        ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                    )
                        : Container(),
                  ),
                  if (_isVideoClicked)
                    ...[
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: _controller != null
                            ? Slider(
                          min: 0.0,
                          max: _controller!.value.duration.inSeconds.toDouble(),
                          value: _sliderValue,
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          onChanged: (newValue) {
                            setState(() {
                              _sliderValue = newValue;
                              _controller!.seekTo(Duration(seconds: newValue.toInt()));
                            });
                          },
                        )
                            : Container(),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: _controller != null
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _controller!.seekTo(_controller!.value.position - Duration(seconds: 10));
                              },
                              child: Icon(Icons.fast_rewind),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_controller!.value.isPlaying) {
                                  _controller!.pause();
                                  _isPlaying = false;
                                } else {
                                  _controller!.play();
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
                                _controller!.seekTo(_controller!.value.position + Duration(seconds: 10));
                              },
                              child: Icon(Icons.fast_forward),
                            ),
                            Text(
                              formatDuration(_controller!.value.position),
                              style: const TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LandscapeVideo(url: _controller!.dataSource)),
                                );
                              },
                              child: Icon(Icons.fullscreen),
                            ),
                          ],
                        )
                            : Container(),
                      ),
                    ],
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Text(
                      'Lecture Notes',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      maximumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    onPressed: () {

                    },
                    child: const Center(
                      child: Text(
                        'Download Notes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
  }
}
