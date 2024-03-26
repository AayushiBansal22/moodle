import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:moodle/common_params/navBar.dart';
import 'package:moodle/sidebar_pages/home_pages/semestersGrid.dart';
import 'package:moodle/common_params/screenSize.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            maximumSize: Size(ScreenSize.widthPercentage(context, 35.14), ScreenSize.heightPercentage(context, 5.01)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'addSemester');
          },
          child: Center(
            child: Text(
              'Add Semester',
              style: const TextStyle(
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
    print('width is');
    print(ScreenSize.widthPercentage(context, 5.093));
    print(ScreenSize.heightPercentage(context, 1.976));
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: NavBar(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          toolbarHeight: ScreenSize.heightPercentage(context, 13.17),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SemesterSearch()
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications_none_outlined),
              color: Colors.white,
              onPressed: () async {
                Navigator.pushNamed(context, 'notifications');
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, ScreenSize.widthPercentage(context, 12), 0),
                  child: IconButton(
                    icon: Icon(Icons.person),
                    iconSize: ScreenSize.heightPercentage(context, 2.634),
                    color: Colors.white,
                    onPressed: () async{
                      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                      String name = docSnapshot['name'] ?? 'User';
                      String profilePictureUrl = user.photoURL ?? '';

                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width - 150.0,
                          MediaQuery.of(context).padding.top + AppBar().preferredSize.height + 10.0,
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).padding.top + AppBar().preferredSize.height + 10.0 + 300.0,
                        ),
                        items: [
                          PopupMenuItem(
                            child: Container(
                              height: ScreenSize.heightPercentage(context, 32.926),
                              width: ScreenSize.widthPercentage(context, 63.658),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: ScreenSize.heightPercentage(context, 2.634)),
                                  profilePictureUrl.isEmpty
                                      ? Icon(
                                    Icons.account_circle,
                                    size: ScreenSize.heightPercentage(context, 15.805),
                                  )
                                      : CircleAvatar(
                                    backgroundImage: NetworkImage(profilePictureUrl),
                                    radius: ScreenSize.heightPercentage(context, 6.62),
                                  ),
                                  SizedBox(height: ScreenSize.heightPercentage(context, 1.32)),
                                  Text(name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: ScreenSize.heightPercentage(context, 3.29)),
                                  ElevatedButton(
                                    child: Text(
                                      "View Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(3)
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'viewProfile');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14,0,14,2),
                  child: Text(
                    user.email!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
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
                        'My Semesters',
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
                  child: Text(
                    'My Semesters',
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
          SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
          Expanded(
            child: SemestersGrid(),
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
      )
    );
  }
}

class SemesterSearch extends SearchDelegate<String> {
  final CollectionReference semesters = FirebaseFirestore.instance.collection('semesters');

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, ''),
    icon: const Icon(Icons.arrow_back_outlined),
    color: Colors.grey[500],
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear_outlined),
        color: Colors.grey[500],
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: semesters.where('title', isGreaterThanOrEqualTo: query).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.black,)
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> display = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(display['title']),
              subtitle: Text(display['description']),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: semesters.where('title', isGreaterThanOrEqualTo: query).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.black,)
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> display = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(display['title']),
              subtitle: Text(display['description']),
            );
          }).toList(),
        );
      },
    );
  }
}
