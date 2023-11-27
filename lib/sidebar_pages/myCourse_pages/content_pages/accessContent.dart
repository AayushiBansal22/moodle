import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccessContent extends StatefulWidget {
  final String conTitle;
  String? courseId;
  AccessContent({Key? key, required this.conTitle, required this.courseId}) : super(key: key) {
    print('courseId in AccessContent constructor: $courseId');
  }

  @override
  State<AccessContent> createState() => _AccessContentState();
}

class _AccessContentState extends State<AccessContent> {
  VideoPlayerController? _controller;
  String id = '';

  Future<String> fetchVideoUrl() async {
    String? id = await widget.courseId;
    if (id != null) {
      log(id);
      log(widget.conTitle);
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('courses').doc(id).collection('content')
          .where('conTitle', isEqualTo: widget.conTitle).get()
          .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.first;
      });
      return documentSnapshot['fileURL'];
    } else {
      log('course id is null');
      throw Exception('courseId is null');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await fetchVideoUrl().then((url) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _controller!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
        )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
