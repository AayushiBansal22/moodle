import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle/common_params/commonAppBar.dart';
import 'package:moodle/common_params/screenSize.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import 'package:moodle/common_params/navBar.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/content_pages/contentDisplay.dart';
import 'package:moodle/courseIdModel.dart';


class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final user = FirebaseAuth.instance.currentUser!;
  String? courseId;

  @override
  void initState() {
    super.initState();
    courseId = Provider.of<CourseIdModel>(context, listen: false).courseId;
    log('$courseId');
  }

  Future<Container> getUserRole() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(
        user.uid).get();
    String role = docSnapshot['role'];
    if (role == 'instructor' || role == 'admin') {
      return Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              maximumSize: Size(ScreenSize.widthPercentage(context, 35.65), ScreenSize.heightPercentage(context, 5.005)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            onPressed: () {
              Provider.of<CourseIdModel>(context, listen: false).setCourseId(courseId!);
              Navigator.pushNamed(context, 'addContent');
            },
            child: const Center(
              child: Text(
                'Add Content',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: NavBar(),
        appBar: CommonAppBar(),
        body: Column(
          children: [
            SizedBox(height: ScreenSize.heightPercentage(context, 2.634),),
            FutureBuilder(
                future: getUserRole(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Container container = snapshot.data ?? Container();
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20, ScreenSize.heightPercentage(context, 2.634), 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Content',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          container,
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20, ScreenSize.heightPercentage(context, 2.634), 20, 0),
                      child: const Text(
                        'My Content',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                }
            ),
            SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
            Expanded(
              child: ContentDisplay(courseId: courseId!),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'courses');
                },
                child: Text(
                  'View All',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}