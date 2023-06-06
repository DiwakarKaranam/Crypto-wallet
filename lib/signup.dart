import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin_wallet/main.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:text_divider/text_divider.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({Key? key}) : super(key: key);

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  bool isVisiblePassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("UsersData");

  Widget buildSuffixIcon() {
    if (isVisiblePassword == true) {
      return IconButton(
        onPressed: () {
          setState(() {
            isVisiblePassword = false;
          });
        },
        icon: Icon(
          Icons.visibility_rounded,
          color: Colors.blue,
        ),
      );
    } else {
      return IconButton(
        onPressed: () {
          setState(() {
            isVisiblePassword = true;
          });
        },
        icon: Icon(
          Icons.visibility_off_rounded,
          color: Colors.blue,
        ),
      );
    }
  }

  Widget buildTextfield(String hintText, IconData icon, bool isObscured, int ms,
      TextEditingController controller) {
    return DelayedDisplay(
      delay: Duration(milliseconds: ms),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              spreadRadius: 0,
              blurRadius: 10,
              color: Colors.blue,
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          controller: controller,
          obscureText: isObscured ? isVisiblePassword : false,
          decoration: InputDecoration(
            suffixIcon: isObscured ? buildSuffixIcon() : null,
            prefixIcon: Icon(
              icon,
              color: Colors.blue,
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 500),
                child: Text(
                  "Sign Up!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.1,
                  ),
                ),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 750),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: screenWidth * 0.8,
                  child: Text(
                    "Let the magic of our app transform your day-to-day tasks into a seamless and enjoyable experience.",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      height: screenHeight * 0.0015,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              buildTextfield("Enter Username", Icons.person_outlined, false,
                  1000, _nameController),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              buildTextfield("Enter your Email", Icons.email_outlined, false,
                  1250, _emailController),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              buildTextfield("Enter your Password", Icons.lock_outlined, true,
                  1500, _passwordController),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1750),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text)
                          .then((value) async {
                        for (int i = 0; i < 5; i++) print('hi\n');
                        print('success');
                        _db
                            .doc(value.user?.uid)
                            .set({
                              "Email": _emailController.text,
                              "Name": _nameController.text,
                              "Password": _passwordController.text,
                              "countofeth": 500
                            })
                            .then((value) => print("User Added"))
                            .catchError(
                                (error) => print("Failed to add user: $error"));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CryptoWalletApp()),
                        );
                      }).onError((error, stackTrace) {
                        print('${error.toString()}hi\nhi\nhi\nhi\nhi\n');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(screenWidth, screenHeight * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 2000),
                child: TextDivider.horizontal(
                  text: Text(
                    "Or Login with",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  thickness: 5,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 2500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLoginPage()),
                        );
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
