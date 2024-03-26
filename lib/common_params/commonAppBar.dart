import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle/common_params/screenSize.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  CommonAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(80);
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        toolbarHeight: ScreenSize.heightPercentage(context, 13.17),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            color: Colors.white,
            onPressed: () {
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
                  iconSize: ScreenSize.heightPercentage(context, 2.8),
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
    );
  }
}