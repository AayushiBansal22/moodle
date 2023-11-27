import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:moodle/commonAppBar.dart';
import 'package:moodle/navBar.dart';
import 'package:moodle/courseIdModel.dart';
import 'dart:developer';

class AddContent extends StatefulWidget {
  const AddContent({super.key});

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  FilePickerResult? _file;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;
  final user = FirebaseAuth.instance.currentUser!;
  String? courseId;

  @override
  void initState() {
    super.initState();
    courseId = Provider.of<CourseIdModel>(context, listen: false).courseId;
    log('$courseId');
  }

  Future<String?> addCourseContent(String docID) async {
    Reference ref = FirebaseStorage.instance.ref("content/${_file!.files.single.name}");
    UploadTask uploadTask = ref.putData(_file!.files.single.bytes!);

    await uploadTask.whenComplete(() async {
      String downloadURL = await ref.getDownloadURL();
      log("Download URL: $downloadURL");

      log(docID);

      CollectionReference content = FirebaseFirestore.instance.collection('courses').doc(docID).collection('content');
      await content.add({
        'conTitle': titleController.text,
        'conDescription': descriptionController.text,
        'fileURL': downloadURL
      });

      await content.where('conTitle', isEqualTo: 'No Content Added').get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete().catchError((error) {
            log("Failed to delete document: $error");
          });
        });
      });

      return downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: NavBar(),
      appBar: CommonAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Text('Provide New Content Details',
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
                        return 'Chapter Name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      titleController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Chapter Name ',
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
                        return 'Chapter Description is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      descriptionController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Chapter Description',
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
                const SizedBox(height: 20,),
                ElevatedButton(
                  child: Text('Upload Content'),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                        withData: true,
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'zip', 'rar', 'mp4', 'mov', 'mp3', 'jpg', 'jpeg', 'png', 'gif', 'svg', 'ipynb'],
                        allowMultiple: true
                    );

                    if(result != null) {
                      setState(() {
                        _file = result;
                      });
                      print('Selected file name: ${_file!.files.single.name}');
                      Text('Content selected', style: TextStyle(color: Colors.black),);
                    } else {
                      print('No file selected');
                    }
                  },
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
                      onPressed: () async {
                        await addCourseContent(courseId!);
                        Navigator.pop(context);
                      },
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
                    )
                ),
              ],
            ),
          ),
      ),
    );
  }
}