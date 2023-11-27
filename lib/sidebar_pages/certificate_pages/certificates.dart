import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:moodle/commonAppBar.dart';
import 'package:moodle/navBar.dart';
import 'package:moodle/sidebar_pages/certificate_pages/certificatesDisplay.dart';

class Certificates extends StatefulWidget {
  const Certificates({super.key});

  @override
  State<Certificates> createState() => _CertificatesState();
}

class _CertificatesState extends State<Certificates> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<Container> getUserRole() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(
        user.uid).get();
    String role = docSnapshot['role'];
    if (role == 'instructor' || role == 'admin') {
      return Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              maximumSize: const Size(140, 38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'addCertificate');
            },
            child: const Center(
              child: Text(
                'Add Certificate',
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
          FutureBuilder(
            future: getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Container container = snapshot.data ?? Container();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Certificates',
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
              }
              else {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    'My Certificates',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 10,),
          Expanded(
              child: CertificatesDisplay(),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'courses');
              },
              child: const Text(
                'View All',
                style: TextStyle(
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
