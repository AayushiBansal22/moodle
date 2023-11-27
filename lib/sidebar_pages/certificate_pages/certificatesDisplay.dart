import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodle/main.dart';
import 'dart:developer';

class CertificatesDisplay extends StatelessWidget {
  CertificatesDisplay({super.key});

  final CollectionReference certificates = FirebaseFirestore.instance.collection('certificates');
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> deleteCertificate(String docID, String title) async {
    // Delete the document from Firestore
    await FirebaseFirestore.instance
        .collection('certificates')
        .doc(docID)
        .delete();

    // Delete the file from Firebase Storage
    await FirebaseStorage.instance
        .ref('certificates/$title.pdf')
        .delete();
  }

  Future<Container> getUserRole (DocumentSnapshot certificate) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(
        user.uid).get();
    String role = docSnapshot['role'];
    if (role == 'instructor' || role == 'admin') {
      return Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              maximumSize: const Size(150, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            onPressed: () async {
              await deleteCertificate(certificate.id, certificate['title']);
            },
            child: const Center(
              child: Text(
                'Delete Certificate',
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
      return Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              maximumSize: const Size(175, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            onPressed: () {
              navigatorKey.currentState!.pushNamed('downloadCertificate', arguments: {
                'certificateUrl': certificate['fileURL'].toString(),
                'certificateName': certificate['title'].toString(),
              });
            },
            child: const Center(
              child: Text(
                'Download Certificate',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: certificates.snapshots(),
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
            DocumentSnapshot certificate = snapshot.data!.docs[index];
            Map<String, dynamic> display = certificate.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 3.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30,25,30,10),
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
                    Text(
                      display['title'],
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 15,),
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
                    const SizedBox(height: 15,),
                    FutureBuilder(
                      future: getUserRole(certificate),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Container container = snapshot.data ?? Container();
                          return container;
                        } else {
                          return Container();
                        }
                      }
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2,
          ),
        );
      },
    );
  }
}
