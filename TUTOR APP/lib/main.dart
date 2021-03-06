// @dart=2.9
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tutorapp/addprofileimage.dart';
import 'package:tutorapp/createprofilepage.dart';
import 'package:tutorapp/homepage.dart';
import 'package:tutorapp/prothomPage.dart';
import 'package:tutorapp/routes/generate_routes.dart';
import 'package:tutorapp/routes/route_names.dart';
import 'package:tutorapp/studentfirstpage.dart';

import 'bloc/photo_bloc.dart';

class CommonThings {
  static Size size;
}

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
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoBloc(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'VisbyRoundCF-Medium',
            primaryColor: Colors.blue[900],
            backgroundColor: Colors.lightBlueAccent,
          ),
          title: 'TUTOR HUB',
          home: IntroScreen(),
          navigatorObservers: <NavigatorObserver>[observer],
          // initialRoute: routeHome,
          onGenerateRoute: RouteGenerator.generateRoute,
          routes: {
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/home': (context) => HomePage(),
            '/createprofile': (context) => CreateProfilePage(),
            '/addprofileimage': (context) => AddProfileImage(),
            '/studentfirstpage': (context) => StudentFirstPage()
          },
        ),
      ),
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
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: 'VisbyRoundCF',
          ),
        ),
        image: Image.asset('assets/images/tutorhub_logo.PNG',
            fit: BoxFit.scaleDown),
        backgroundColor: Colors.blue[100],
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.transparent);
  }
}
