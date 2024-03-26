import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodle/common_params/screenSize.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  String errorMessage = '';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Form(
        key: _key,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: ScreenSize.heightPercentage(context, 13.17),),
              Icon(
                Icons.lock,
                size: ScreenSize.heightPercentage(context, 13.17),
              ),
              SizedBox(height: ScreenSize.heightPercentage(context, 6.59),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('Enter the registered email address at which you wish to receive the password reset link',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.heightPercentage(context, 4.61),),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: emailController,
                  validator: validateEmail,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Username',
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
                padding: EdgeInsets.symmetric(vertical: ScreenSize.heightPercentage(context, 3.29), horizontal: 75),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Send Link',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async{
                      setState(() {
                        errorMessage = '';
                      });
                      if (_key.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
                        } on FirebaseAuthException catch(error) {
                          errorMessage = error.message!;
                        }
                      }
                    },
                ),
              ),
            ],
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