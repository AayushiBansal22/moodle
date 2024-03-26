import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle/common_params/screenSize.dart';

class SemestersGrid extends StatelessWidget {
  SemestersGrid({super.key});

  final CollectionReference semesters = FirebaseFirestore.instance.collection('semesters');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: semesters.snapshots(),
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
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: ScreenSize.heightPercentage(context, 1.32)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: ScreenSize.heightPercentage(context, 1.32)),
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
                    SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                    Text(
                      display['title'],
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height: ScreenSize.heightPercentage(context, 2.634),),
                    Container(
                      height: ScreenSize.heightPercentage(context, 9.22),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Text(
                            display['description'],
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: ScreenSize.heightPercentage(context, 0.79)),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            maximumSize: Size(ScreenSize.widthPercentage(context, 34.375), ScreenSize.heightPercentage(context, 5.27)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'myCourses');
                          },
                          child: Center(
                            child: Text(
                              'View Semester',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (ScreenSize.screenWidth(context) / ScreenSize.screenHeight(context)) * 1.65,
          ),
        );
      },
    );
  }
}