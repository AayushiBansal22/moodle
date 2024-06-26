import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:moodle/common_params/commonAppBar.dart';
import 'package:moodle/common_params/navBar.dart';
import 'package:moodle/common_params/screenSize.dart';
import 'package:moodle/updateProfile.dart';


class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<Map<String, dynamic>> getUserDetails() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String role = docSnapshot['role'];
    String name = docSnapshot['name'];
    String email = docSnapshot['email'];
    //String? profilePictureUrl = docSnapshot['profilePictureUrl'];
    return {'role': role, 'name': name, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: NavBar(),
      appBar: CommonAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,20,20,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        maximumSize: Size(ScreenSize.widthPercentage(context, 35.65), ScreenSize.heightPercentage(context, 5.005)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProfile(docId: user.uid),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 15,
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
          FutureBuilder(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic>? userDetails = snapshot.data;
                return Padding(
                  padding: EdgeInsets.fromLTRB(ScreenSize.widthPercentage(context, 5.093), ScreenSize.heightPercentage(context, 3.95), ScreenSize.widthPercentage(context, 5.093), ScreenSize.heightPercentage(context, 1.32)),
                  child: Column(
                    children: [
                      Icon(Icons.account_circle, size: 180),
                      SizedBox(height: ScreenSize.heightPercentage(context, 1.976),),
                      Text(
                        'Name: ${userDetails!['name']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                      Text(
                        'Bio: I am ${userDetails['role']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF616161),
                        ),
                      ),
                      SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                      Text(
                        'Email: ${userDetails['email']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
