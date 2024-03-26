import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:moodle/common_params/commonAppBar.dart';
import 'package:moodle/common_params/navBar.dart';

class AddGrades extends StatefulWidget {
  const AddGrades({super.key});

  @override
  State<AddGrades> createState() => _AddGradesState();
}

class _AddGradesState extends State<AddGrades> {
  final titleController = TextEditingController();
  final gradeController = TextEditingController();
  final usernameController = TextEditingController();
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
                Text('Provide Grade Details',
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
                        return 'Course Name is required';
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
                    controller: usernameController,
                    validator: (value){
                      if(value == null || value!.isEmpty){
                        return 'Student Username is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      usernameController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Student Username',
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
                    controller: gradeController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Course Grade is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      gradeController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Course Grade',
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
                const SizedBox(height: 10,),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(errorMessage,
                        style: TextStyle(color: Colors.red)
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
                          'Submit',
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
                            CollectionReference grades = FirebaseFirestore.instance.collection('grades');
                            grades.add({
                              'title': titleController.text,
                              'username': usernameController.text,
                              'grade': gradeController.text,
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
