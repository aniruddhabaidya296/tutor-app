// @dart=2.12
import 'dart:convert';
// import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:student/createprofilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:student/googlesignin.dart';
import 'package:student/homepage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:uuid/uuid.dart';
import 'emaillogin.dart';
import 'emailsignup.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
final FirebaseAuth auth = FirebaseAuth.instance;
GoogleSignIn googleHomePageUserSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    // 'https://www.googleapis.com/auth/cloud-platform',
  ],
);

class ProthomPage extends StatefulWidget {
  const ProthomPage({Key? key}) : super(key: key);

  @override
  _ProthomPageState createState() => _ProthomPageState();
  void handleSignIn() async {
    try {
      await googleHomePageUserSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}

class _ProthomPageState extends State<ProthomPage> {
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
  ///      _____     ______     ______      _____    __        _________    ///
  ///     #######    ######     ######     #######   ##|       #########|   ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|        ##|   ##|  ##|   ##|  ##|        ##|       ##|____      ///
  ///    ##|   ###  ##|   ##|  ##|   ##|  ##|   ###  ##|       #######|     ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|____##  ##|___##|  ##|___##|  ##|____##  ##|_____  ##|______    ///
  ///     #######    ######     ######     #######   ########| #########|   ///
  ///                                                                       ///
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//---------------WARNING: DO NOT CHANGE ANYTHING HERE!-----------------------
//---------------WARNING: DO NOT CHANGE ANYTHING HERE!-----------------------
//---------------WARNING: DO NOT CHANGE ANYTHING HERE!-----------------------
//---------------WARNING: DO NOT CHANGE ANYTHING HERE!-----------------------
//---------------WARNING: DO NOT CHANGE ANYTHING HERE!-----------------------

  GoogleSignInAccount? _currentUser;
  // String _contactText = '';
  String uid = '';

  @override
  void initState() {
    super.initState();
    googleHomePageUserSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        print("_current user: $_currentUser###########################");
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    googleHomePageUserSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    final Map<String, dynamic> data = json.decode(response.body);
    //Will be using it later. !!!DO NOT DELETE!!!
  }

  void handleSignIn() async {
    try {
      await googleHomePageUserSignIn.signIn();
      GoogleSignInAccount googleSignInAccount =
          await googleHomePageUserSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      // String credentialText = credential.toString();
      UserCredential authResult = await auth.signInWithCredential(credential);
      User? firebaseUser = authResult.user;
      dbRef.child(authResult.user!.uid).set({
        "user email": firebaseUser!.email,
        // "credential": credentialText,
        "name": firebaseUser.displayName,
        "uid": authResult.user!.uid
      });
      uid = authResult.user!.uid;
    } catch (error) {
      print(error);
    }
  }

  void handleSignOut() => googleHomePageUserSignIn.disconnect();

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
  ///      _____     ______     ______      _____    __        _________    ///
  ///     #######    ######     ######     #######   ##|       #########|   ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|        ##|   ##|  ##|   ##|  ##|        ##|       ##|____      ///
  ///    ##|   ###  ##|   ##|  ##|   ##|  ##|   ###  ##|       #######|     ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|    ##  ##|   ##|  ##|   ##|  ##|    ##  ##|       ##|          ///
  ///    ##|____##  ##|___##|  ##|___##|  ##|____##  ##|_____  ##|______    ///
  ///     #######    ######     ######     #######   ########| #########|   ///
  ///                                                                       ///
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            primaryColor: Colors.blue,
            backgroundColor: Colors.lightBlueAccent,
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.blue[400],
                textTheme: ButtonTextTheme.primary)),
        child: Builder(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Sign Up"),
              ),
              body: Center(
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Padding(
                        //   padding: EdgeInsets.all(10.0),
                        //   child: Text("WELCOME",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 30,
                        //           fontFamily: 'Roboto')),
                        // ),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SignInButton(
                              Buttons.Email,
                              text: "Sign in with Email",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmailLogIn()),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.only(left: 50),
                              elevation: 10,
                            )),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SignInButton(
                              Buttons.Google,
                              text: "Sign In with Google",
                              onPressed: () {
                                handleSignIn();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => googleSignIn()));
                                // googleSignIn();
                                // googleSignInUser.handleSignIn();
                                // debugPrint("Now adding data to firebase");
                                // signInWithGoogle();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    ModalRoute.withName('/home'));
                              },
                              padding: EdgeInsets.only(left: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
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
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmailSignUp()),
                                  );
                                }))
                      ]),
                ),
              ));
        }));
  }
}
