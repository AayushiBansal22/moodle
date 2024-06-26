import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:moodle/common_params/commonAppBar.dart';
import 'package:moodle/common_params/navBar.dart';
import 'package:moodle/common_params/screenSize.dart';

class AddSemester extends StatefulWidget {
  const AddSemester({super.key});

  @override
  State<AddSemester> createState() => _AddSemesterState();
}

class _AddSemesterState extends State<AddSemester> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: NavBar(),
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: ScreenSize.heightPercentage(context, 6.59),),
                Text('Provide Semester Details',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 4.61),),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: titleController,
                    validator: (value){
                      if(value == null || value!.isEmpty){
                        return 'Semester name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      titleController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Semester Name',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 2.634),),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    maxLines: null,
                    controller: descriptionController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Semester description is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      descriptionController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Semester Description',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      contentPadding: EdgeInsets.fromLTRB(10,ScreenSize.heightPercentage(context, 1.98),20,ScreenSize.heightPercentage(context, 13.17)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(errorMessage,
                        style: TextStyle(color: Colors.red)
                    )
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 3.29),),
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: ScreenSize.heightPercentage(context, 3.29)),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Create Semester',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                          errorMessage = '';
                        });
                        if (_key.currentState!.validate()) {
                          try {
                            _key.currentState!.save();
                            final isTitleValid = await validateTitle(titleController.text);
                            if (!isTitleValid) {
                              setState(() {
                                errorMessage = 'Semester name already exists';
                                isLoading = false;
                              });
                              return;
                            }
                            CollectionReference semesters = FirebaseFirestore.instance.collection('semesters');
                            semesters.add({
                              'title': titleController.text,
                              'description': descriptionController.text,
                            });
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (error) {
                            errorMessage = error.message!;
                          }
                          setState(() => isLoading = false);
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> validateTitle(String title) async {
  final semesters = FirebaseFirestore.instance.collection('semesters');
  final querySnapshot = await semesters.where('title', isEqualTo: title).get();

  if (querySnapshot.docs.isEmpty) {
    return true;
  } else {
    return false;
  }
}