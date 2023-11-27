import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodle/sidebar_pages/certificate_pages/certificates.dart';
import 'package:moodle/sidebar_pages/grades_pages/grades.dart';
import 'package:moodle/sidebar_pages/myCourse_pages/myCourses.dart';
import 'package:moodle/sidebar_pages/home_pages/home.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.2,
            ),
            Divider(
              color: Colors.white,
              thickness: 0.9,
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.home_outlined),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              title: Text("Home",
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 0.9,
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.menu_book_outlined),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyCourses()),
                  );
                },
              ),
              title: Text("My Courses",
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 0.9,
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.collections_bookmark),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Certificates()),
                  );
                },
              ),
              title: Text("Certificates",
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 0.9,
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.grade_outlined),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Grades()),
                  );
                },
              ),
              title: Text("Grades",
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 0.9,
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.logout),
                color: Colors.white,
                onPressed: () => signOut(),
              ),
              title: Text("Logout",
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 0.9,
            ),
          ],
        ),
      ),
    );
  }
}
