// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:student/createprofilepage.dart';
import 'package:student/homepage.dart';
import 'package:student/prothomPage.dart';
// import 'signup.dart';

Future<UserCredential> signInWithGoogle() async {
  await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue[900],
          backgroundColor: Colors.lightBlueAccent,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue[400],
              textTheme: ButtonTextTheme.primary)),
      title: 'TUTOR HUB',
      home: IntroScreen(),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomePage(),
        '/createprofile': (context) => CreateProfilePage(),
      },
    );
  }
}

class IntroScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    User result = FirebaseAuth.instance.currentUser;
    return SplashScreen(
        navigateAfterSeconds:
            result != null ? HomePage(uid: result.uid) : ProthomPage(),
        seconds: 5,
        title: new Text(
          'Welcome To Tutor Hub',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('assets/tutorhub_logo.PNG', fit: BoxFit.scaleDown),
        backgroundColor: Colors.lightBlue[300],
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.transparent);
  }
}
