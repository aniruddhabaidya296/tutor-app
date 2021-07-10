import 'package:flutter/material.dart';
import 'package:tutorapp/studentfirstpage.dart';
import 'package:tutorapp/teacherfirstpage.dart';
import 'homepage.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({Key? key}) : super(key: key);

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

var user;

class _CreateProfilePageState extends State<CreateProfilePage> {
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
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          "CREATE PROFILE",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/tutorhub_logo.PNG'),
                  fit: BoxFit.contain,
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 5,
                color: Colors.blue,
                onPressed: () {
                  user = "Teacher";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TeacherFirstPage()));
                },
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "I AM A TEACHER",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'VisbyRoundCF',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(30),
              // ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 5,
                color: Colors.blue,
                onPressed: () {
                  user = "Student";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentFirstPage()));
                },
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "I AM A STUDENT",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'VisbyRoundCF',
                          fontWeight: FontWeight.bold),
                    )),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
