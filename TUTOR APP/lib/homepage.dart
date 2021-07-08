// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorapp/createprofilepage.dart';
import 'package:tutorapp/prothomPage.dart';

// import 'package:student/signup.dart';
// import 'googlesignin.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn();

void handleSignOut() => _googleSignIn.disconnect();

class HomePage extends StatefulWidget {
  const HomePage({Key? key, String? uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // void onLoading() {
  //   setState(() {
  //     loading = true;
  //     new Future.delayed(new Duration(seconds: 3), login);
  //   });
  // }

  // Future login() async {
  //   setState(() {
  //     loading = false;
  //   });
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    final size = MediaQuery.of(context).size;
    return Theme(
        data: ThemeData(
            dialogBackgroundColor: Colors.blue[100],
            primaryColor: Colors.blue,
            backgroundColor: Colors.lightBlueAccent,
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.blue[400],
                textTheme: ButtonTextTheme.primary)),
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              actions: <Widget>[
                Builder(builder: (BuildContext context) {
                  return TextButton(
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                title: Text("Log Out"),
                                content: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text("Are you sure you want to log out?"),
                                    SizedBox(height: 60),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            final User? user =
                                                await _auth.currentUser;
                                            googleHomePageUserSignIn.signOut();
                                            if (user != null) {
                                              await _auth.signOut();
                                              final String? email = user.email;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(email! +
                                                    ' has successfully signed out.'),
                                              ));
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProthomPage()),
                                                  ModalRoute.withName('/'));
                                            }
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: Colors.blue))),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.blue),
                                              elevation:
                                                  MaterialStateProperty.all(5)),
                                        ),
                                        SizedBox(width: 20),
                                        ElevatedButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: Colors.blue))),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.blue),
                                              elevation:
                                                  MaterialStateProperty.all(5)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
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
                child:
                    ListView(controller: ScrollController(), children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    fontFamily: 'VisbyRoundCF',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    labelText: "Search",
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontFamily: 'VisbyRoundCF',
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue[100]),
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 150,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 0.7,
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: size.width / 30),
                                  Text(
                                    "Complete my profile",
                                    style: TextStyle(
                                        fontFamily: 'VisbyRoundCF',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: size.width / 30),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          minimumSize: MaterialStateProperty.all(
                                              Size(80, 40)),
                                          shape:
                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: Colors.blue))),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                          elevation:
                                              MaterialStateProperty.all(10)),
                                      // color: Colors.blue[400],
                                      // elevation: 10,
                                      child: Text("Go"),
                                      onPressed: () =>
                                          {Navigator.pushNamed(context, '/createprofile')}),
                                  SizedBox(width: size.width / 30),
                                ])),
                      )))
            ])),
          );
        }));
  }
}
