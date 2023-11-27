import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:moodle/courseIdModel.dart';

class CoursesGrid extends StatefulWidget {
  CoursesGrid({super.key});

  @override
  State<CoursesGrid> createState() => _CoursesGridState();
}

class _CoursesGridState extends State<CoursesGrid> {
  final CollectionReference courses = FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          Navigator.pushReplacementNamed(context, 'login');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot course = snapshot.data!.docs[index];
            Map<String, dynamic> display = course.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0)
                ),
                child: Column(
                  children: [
                    /*Image.asset(
                        course.image,
                        height: 100,
                    ),*/
                    const SizedBox(height: 10,),
                    Text(
                      display['title'],
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      height: 50,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Text(
                            display['description'],
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          maximumSize: const Size(125, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        onPressed: () async {
                          String courseId = course.id;
                          log(courseId);
                          Provider.of<CourseIdModel>(context, listen: false).setCourseId(courseId);
                          Navigator.pushNamed(context, 'content');
                        },
                        child: const Center(
                          child: Text(
                            'View Course',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
          ),
        );
      },
    );
  }
}