import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodle/login_pages/forgotPassword.dart';
import 'package:moodle/common_params/screenSize.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                  size: ScreenSize.heightPercentage(context, 13.17),
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 6.59),),
                Text('Welcome Back',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700]
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
                  child: TextFormField(
                    controller: passwordController,
                    validator: validatePassword,
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
                  child: Text(errorMessage,
                      style: TextStyle(color: Colors.red)
                    )
                ),
                SizedBox(height: ScreenSize.heightPercentage(context, 1.32),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.grey[600],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      child: Center(
                        child: Text(
                          'Sign In',
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
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
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
                          Navigator.pushNamed(context, 'register');
                        },
                        child: Text(
                          'Don\'t have an account?',
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