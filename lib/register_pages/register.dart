import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle/register_pages/userModel.dart';
import 'package:moodle/common_params/screenSize.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: ScreenSize.heightPercentage(context, 6.59),),
                Icon(
                  Icons.lock,
                  size: ScreenSize.heightPercentage(context, 6.59),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 4.61),),
                Text('Create New User', style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700]
                ),),
                SizedBox(height: ScreenSize.heightPercentage(context, 4.61),),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: fullNameController,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{3,}$');
                      if (value == null || value!.isEmpty) {
                        return ("Name is required");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter valid name (Min. 3 Character)");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fullNameController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: emailController,
                    validator: validateEmail,
                    onSaved: (value) {
                      emailController.text = value!;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: passwordController,
                    validator: validatePassword,
                    onSaved: (value) {
                      passwordController.text = value!;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (confirmPasswordController.text != passwordController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confirmPasswordController.text = value!;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)
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
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: user != null
                          ? null
                          : () async {
                        setState(() {
                          isLoading = true;
                          errorMessage = '';
                        });
                        if (_key.currentState!.validate()) {
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                            DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
                            await docRef.set({
                              'role': 'student',
                              'name': fullNameController.text,
                              'email': emailController.text,
                            });
                          } on FirebaseAuthException catch (error) {
                            errorMessage = error.message!;
                          }
                          setState(() => isLoading = false);
                        }
                      }
                  ),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 3.95),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
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

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'E-mail address is required';

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail))
    return 'Invalid E-mail Address.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'Password is required';

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return 'Incorrect Password';

  return null;
}