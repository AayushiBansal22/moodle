import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:moodle/commonAppBar.dart';
import 'package:moodle/navBar.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
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
                const SizedBox(height: 50,),
                Text('Provide Course Details',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700]
                  ),
                ),
                const SizedBox(height: 35,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: titleController,
                    validator: (value){
                      if(value == null || value!.isEmpty){
                        return 'Course name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      titleController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Course Name',
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
                const SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    maxLines: null,
                    controller: descriptionController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Course description is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      descriptionController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Course Description',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      contentPadding: const EdgeInsets.fromLTRB(10,15,20,100),
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
                const SizedBox(height: 10,),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(errorMessage,
                        style: const TextStyle(color: Colors.red)
                    )
                ),
                const SizedBox(height: 25,),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(25),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Create Course',
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
                                errorMessage = 'Course name already exists';
                                isLoading = false;
                              });
                              return;
                            }
                            log('creating course');
                            CollectionReference courses = FirebaseFirestore.instance.collection('courses');
                            DocumentReference courseRef = await courses.add({
                              'title': titleController.text,
                              'description': descriptionController.text,
                            });
                            log('creating default content');
                            await courseRef.collection('content').doc().set({
                              'conTitle': 'No Content Added',
                              'conDescription': ' ',
                              'fileURL': ' ',
                            });
                            log('course created');
                          } on FirebaseAuthException catch (error) {
                            errorMessage = error.message!;
                          }
                          setState(() => isLoading = false);
                          Navigator.pop(context);
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
  final courses = FirebaseFirestore.instance.collection('courses');
  final querySnapshot = await courses.where('title', isEqualTo: title).get();

  if (querySnapshot.docs.isEmpty) {
    return true;
  } else {
    return false;
  }
}