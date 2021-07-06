import 'package:flutter/material.dart';
import 'createprofilepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

// Widget build(BuildContext context) {
//   return new Scaffold(
//     seconds: 2,
//     imageBackground: AssetImage('assets/tutorhub_logo.PNG'),
//     navigateAfterSeconds: LoginPage(),
//   );
// }

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WELCOME"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("ENTER DETAILS",
                style: TextStyle(fontSize: 30, fontFamily: "Verdana")),
            Padding(
              padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0),
              child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0)),
                      alignLabelWithHint: true,
                      labelText: "Username")),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 50.0, right: 50.0, top: 10.0, bottom: 20.0),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    alignLabelWithHint: true,
                    labelText: "Password"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateProfilePage()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
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
