import 'package:flutter/material.dart';
import 'homepage.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({Key? key}) : super(key: key);

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

var user;

class _CreateProfilePageState extends State<CreateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              width: MediaQuery.of(context).size.width / 1.3,
              child: MaterialButton(
                onPressed: () {
                  user = "Teacher";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "I AM A TEACHER",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.indigo[900]),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: MaterialButton(
                onPressed: () {
                  user = "Student";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "I AM A STUDENT",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.indigo[900]),
            ),
          ],
        ),
      ),
    );
  }
}
