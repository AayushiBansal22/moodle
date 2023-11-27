import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodle/commonAppBar.dart';
import 'package:moodle/navBar.dart';

class AddCertificate extends StatefulWidget {
  const AddCertificate({super.key});

  @override
  State<AddCertificate> createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  FilePickerResult? _file;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

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
              Text('Provide Certificate Details',
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
                      return 'Certificate Title is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    titleController.text = value!;
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Certificate Title ',
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
                      return 'Certificate Description is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    descriptionController.text = value!;
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Certificate Description',
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
                child: Text('Upload Certificate'),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                      withData: true,
                      type: FileType.custom,
                      allowedExtensions: ['pdf']
                  );

                  if(result != null) {
                    setState(() {
                      _file = result;
                    });
                    print('Selected file name: ${_file!.files.single.name}');
                    Text('Certificate selected', style: TextStyle(color: Colors.black),);
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
                          Reference ref = FirebaseStorage.instance.ref("certificates/${_file!.files.single.name}");
                          UploadTask uploadTask = ref.putData(_file!.files.single.bytes!);

                          await uploadTask.whenComplete(() async {
                            String downloadURL = await ref.getDownloadURL();
                            print("Download URL: $downloadURL");

                            CollectionReference certificates = FirebaseFirestore.instance.collection('certificates');
                            await certificates.add({
                              'title': titleController.text,
                              'description': descriptionController.text,
                              'fileURL': downloadURL
                            });

                            return downloadURL;
                          });
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
    );
  }
}
