// import 'dart:html';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorapp/createprofilepage.dart';
import 'package:tutorapp/main.dart';
import 'package:tutorapp/prothomPage.dart';
import 'package:tutorapp/studentfirstpage.dart';
import 'package:tutorapp/teacherfirstpage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'addprofileimage.dart';

bool flag = false;
FirebaseStorage storage = FirebaseStorage.instance;

class UserDetails {
  String displayName = '';
  void init(String name) {
    this.displayName = name;
  }
}
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // var drawerHeader = DrawerHeader(
  //     //     child: CachedNetworkImage(
  //     //   imageUrl:
  //     //       "https://firebasestorage.googleapis.com/v0/b/the-tutor-app-4aed9.appspot.com/o/Images%2Fplaceholder.png?alt=media&token=ad91245d-0a41-4b26-a033-037c5848e173",
  //     //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  //     //       CircularProgressIndicator(
  //     //     value: downloadProgress.progress,
  //     //     strokeWidth: 7.0,
  //     //   ),
  //     //   errorWidget: (context, url, error) => Icon(Icons.error),
  //     // )
  //     child: Image.network(
  //   profileDp,
  //   loadingBuilder:
  //       (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  //     if (loadingProgress == null) return child;
  //     return Center(
  //       child: CircularProgressIndicator(
  //         value: (loadingProgress.expectedTotalBytes != null)
  //             ? loadingProgress.cumulativeBytesLoaded.toDouble() /
  //                 loadingProgress.expectedTotalBytes!.toDouble()
  //             : null,
  //       ),
  //     );
  //   },
  // )

  // CachedNetworkImage(
  //   imageUrl: profileDp,
  //   //"https://firebasestorage.googleapis.com/v0/b/the-tutor-app-4aed9.appspot.com/o/Images%2Fplaceholder.png?alt=media&token=ad91245d-0a41-4b26-a033-037c5848e173",
  //   progressIndicatorBuilder: (context, imageUrl, downloadProgress) =>
  //       CircularProgressIndicator(
  //     value: downloadProgress.progress,
  //     strokeWidth: 7.0,
  //   ),
  //   errorWidget: (context, url, error) => Icon(Icons.error),
  // ),
  // );

  void _openDrawer() async {
    _scaffoldKey.currentState!.openDrawer();
    // if (profileDp != null) {
    // drawerHeader =
    //     DrawerHeader(child: Image.network(profileDp, fit: BoxFit.contain));
    // }
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  Drawer returnDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                    child: Image.network(
                  profileDp,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: (loadingProgress.expectedTotalBytes != null)
                            ? loadingProgress.cumulativeBytesLoaded.toDouble() /
                                loadingProgress.expectedTotalBytes!.toDouble()
                            : null,
                      ),
                    );
                  },
                ))),
          ),
          Expanded(
            flex: 2,
            child: ListView(children: [
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
          )
        ],
      ),
    );
  }

  var isLoading;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadData());
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      profileDp =
          await storage.ref().child('Images/$currentUserId').getDownloadURL();
      print(profileDp);
    } catch (e) {
      profileDp =
          await storage.ref().child('Images/placeholder.png').getDownloadURL();
      print("Check if image exists: $e");
    }
    setState(() {
      isLoading = false;
    });
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
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: Builder(builder: (context) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: returnDrawer(),
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
                            backgroundColor: Colors.blue[100],
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
                                        // profileDp = null;
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
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
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
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
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
                  _openDrawer();
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
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.blue))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                      elevation: MaterialStateProperty.all(10)),
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
