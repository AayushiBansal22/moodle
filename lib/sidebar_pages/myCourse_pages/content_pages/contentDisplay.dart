import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:moodle/main.dart';

class ContentDisplay extends StatelessWidget {
  String? courseId;
  ContentDisplay({Key? key, required this.courseId}) : super(key: key);

  final CollectionReference content = FirebaseFirestore.instance.collection('content');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').doc(courseId!).collection('content').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          Navigator.pushReplacementNamed(context, 'login');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading', style: TextStyle(color: Colors.black, fontSize: 15),));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot content = snapshot.data!.docs[index];
            Map<String, dynamic> display = content.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 5.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      display['conTitle'],
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextButton(
                      onPressed: () {
                        log('$courseId');
                        navigatorKey.currentState!.pushNamed('accessContent', arguments: {
                          'conTitle': display['conTitle'].toString(),
                          'courseId': courseId,
                        });
                      },
                      child: Text(
                        display['conDescription'],
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
