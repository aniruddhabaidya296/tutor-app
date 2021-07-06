// @dart=2.12
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
import 'package:student/createprofilepage.dart';
import 'emaillogin.dart';
import 'emailsignup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'googlesignin.dart';
import 'homepage.dart';

// googleSignIn googleSignInUser = new googleSignIn();

googleSignInState googleUser = new googleSignInState();

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      // 'https://www.googleapis.com/auth/cloud-platform'
    ],
  );

  // GlobalKey<FormState> _userLoginFormKey = GlobalKey();
  // DatabaseReference dbRef =
  //     FirebaseDatabase.instance.reference().child("Users");
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("WELCOME",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'Roboto')),
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SignInButton(
                    Buttons.Email,
                    text: "Sign up with Email",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailSignUp()),
                      );
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => googleSignIn()));
                      // googleSignIn();
                      // googleSignInUser.handleSignIn();
                      // debugPrint("Now adding data to firebase");
                      // signInWithGoogle();
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => HomePage()),
                      //     ModalRoute.withName('/home'));
                    },
                  )),
              // Padding(
              //     padding: EdgeInsets.all(10.0),
              //     child: SignInButton(
              //       Buttons.Twitter,
              //       text: "Sign up with Twitter",
              //       onPressed: () {},
              //     )),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                      child: Text("Log In Using Email",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmailLogIn()),
                        );
                      }))
            ]),
      ),
    );
  }
}
