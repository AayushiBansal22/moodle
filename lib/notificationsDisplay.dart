import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsDisplay extends StatelessWidget {
  NotificationsDisplay({super.key});

  final CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notifications.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          Navigator.pushReplacementNamed(context, 'login');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot notification = snapshot.data!.docs[index];
            Map<String, dynamic> display = notification.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(30,25,30,0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0)
                ),
                child: Column(
                  children: [
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
