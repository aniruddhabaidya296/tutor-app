// @dart=2.12
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tutorapp/homepage.dart';
import 'package:uuid/uuid.dart';
import 'emaillogin.dart';
import 'emailsignup.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

abstract class Person {
  String name;
  String id;
  String role;
  Person(this.name, this.role, this.id) {}
}

String currentUserId = '';

bool loading = true;
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

  handleLoading() async {
    loading = true;
  }

  void handleSignIn() async {
    try {
      loading = true;
      await googleHomePageUserSignIn.signIn();
      GoogleSignInAccount googleSignInAccount =
          await googleHomePageUserSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      // login();
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
      currentUserId = authResult.user!.uid;
      loading = false;
      loading
          ? bodyProgress
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      loading = false;
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
  ///
  var bodyProgress = new Container(
    child: new Stack(
      children: <Widget>[
        new Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white70,
          ),
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.blue[200],
                borderRadius: new BorderRadius.circular(10.0)),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: new Center(
                    child: new Text(
                      "loading.. wait...",
                      style: new TextStyle(
                          fontFamily: "VisbyRoundCF",
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text("Sign Up"),
          ),
          body: Center(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: SignInButton(
                          Buttons.Google,
                          text: "Sign In with Google",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => new Container(
                                      child: new Stack(
                                        children: <Widget>[
                                          new Container(
                                            alignment:
                                                AlignmentDirectional.center,
                                            decoration: new BoxDecoration(
                                              color: Colors.white70,
                                            ),
                                            child: new Container(
                                              decoration: new BoxDecoration(
                                                  color: Colors.blue[200],
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0)),
                                              width: 300.0,
                                              height: 200.0,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  new Center(
                                                    child: new SizedBox(
                                                      height: 50.0,
                                                      width: 50.0,
                                                      child:
                                                          new CircularProgressIndicator(
                                                        value: null,
                                                        strokeWidth: 7.0,
                                                      ),
                                                    ),
                                                  ),
                                                  new SizedBox(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15),
                                                        child: Text(
                                                          "Loading",
                                                          style: new TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontFamily:
                                                                  "VisbyRoundCF",
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                            handleSignIn();
                          },
                          padding: EdgeInsets.only(left: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GestureDetector(
                            child: Text("Sign Up",
                                style: TextStyle(
                                    fontFamily: 'VisbyRoundCF',
                                    fontWeight: FontWeight.bold,
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
