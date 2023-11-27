import 'package:moodle/sidebar_pages/grades_pages/editGrade.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GradesDisplay extends StatelessWidget {
  GradesDisplay({super.key});

  final CollectionReference certificates = FirebaseFirestore.instance.collection('certificates');
  final user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, dynamic>> getUserDetails() async {
    final userId = user.uid;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    final username = userSnapshot.data()!['email'];
    final role = userSnapshot.data()!['role'];
    return {'username': username, 'role': role};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getUserDetails(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text(
              'Loading', style: TextStyle(color: Colors.black, fontSize: 15),
            ));
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else {
            final userDetails = snapshot.data!;
            final username = userDetails['username'];
            final role = userDetails['role'];
            if (role == 'instructor' || role == 'admin') {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('grades').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    Navigator.pushReplacementNamed(context, 'authPage');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Loading',
                      style: TextStyle(color: Colors.black, fontSize: 15),));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot grades = snapshot.data!.docs[index];
                      String docId = grades.id;
                      Map<String, dynamic> display = grades.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    display['title'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          maximumSize: const Size(70, 38),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditGrade(docId: docId),
                                            ),
                                          );
                                        },
                                        child: const Center(
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          maximumSize: const Size(80, 38),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        ),
                                        onPressed: () async{
                                          final docRef = FirebaseFirestore.instance.collection('grades').doc(docId);
                                          await docRef.delete();
                                        },
                                        child: const Center(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    display['username'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    display['grade'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
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
            else {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('grades')
                    .where('username', isEqualTo: username).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    Navigator.pushReplacementNamed(context, 'authPage');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Loading',
                      style: TextStyle(color: Colors.black, fontSize: 15),));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot content = snapshot.data!.docs[index];
                      Map<String, dynamic> display = content.data() as Map<
                          String,
                          dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 5.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    display['title'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    display['grade'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
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
        }
    );
  }
}
