import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/prothomPage.dart';
// import 'package:student/signup.dart';
// import 'googlesignin.dart';

// GoogleSignIn googleUser = new GoogleSignIn();
GoogleSignIn _googleSignIn = new GoogleSignIn();

void handleSignOut() => _googleSignIn.disconnect();

class HomePage extends StatefulWidget {
  const HomePage({Key? key, String? uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignInAccount? _currentUser;
  // void handleSignOut() async {
  //   print("handleSignOut called");
  //   try {
  //     GoogleSignInAccount _currentUser = await _googleSignIn.signIn();
  //     print("$_currentUser============================");
  //     if (_currentUser != null) _googleSignIn.disconnect();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    MoveToBackground.moveTaskToBack();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
//5
            return TextButton(
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                final User? user = await _auth.currentUser;
                // handleSignOut();
                // googleSignInUser.handleSignIn();
                if (user != null) {
                  // handleSignOut();
                  googleHomePageUserSignIn.signOut();
                  await _auth.signOut();
                  final String? email = user.email;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(email! + ' has successfully signed out.'),
                  ));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ProthomPage()),
                      ModalRoute.withName('/'));
                }
                // googleUser.handleSignOut();
              },
            );
          })
        ],
        leading: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                //SideNavBar here
              },
              color: Colors.white,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        title: Text("Home"),
      ),
      body: Center(
          child: ListView(controller: ScrollController(), children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 30, right: 30),
          child: TextFormField(
            cursorColor: Colors.black,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(color: Colors.black38),
              ),
              labelText: "Search",
              suffixIcon: Icon(
                Icons.search,
              ),
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ])),
    );
  }
}
