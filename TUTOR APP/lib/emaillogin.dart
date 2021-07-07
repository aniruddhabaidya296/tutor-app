import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/prothomPage.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'prothomPage.dart';
import 'homepage.dart';

class EmailLogIn extends StatefulWidget {
  const EmailLogIn({Key? key}) : super(key: key);

  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _success;
  String? _userEmail;

  void _signInWithEmailAndPassword() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    var user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            ModalRoute.withName('/home'));
      });
    } else {
      setState(() {
        _success = false;
        Text("Email not registered.");
        TextButton(
            child: Text("Sign Up?"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ProthomPage()),
                  ModalRoute.withName('/'));
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text("Email Sign In"),
            ),
            key: _formKey,
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[100]),
                width: MediaQuery.of(context).size.width / 1.3,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/tutorhub_logo.PNG'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (String? value) {
                          if (value == Null) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        validator: (String? value) {
                          if (value == Null) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        elevation: 10,
                        color: Colors.blue,
                        onPressed: () async {
                          {
                            _signInWithEmailAndPassword();
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _success == null
                            ? ''
                            : (_success
                                ? 'Successfully signed in ' + _userEmail!
                                : 'Sign in failed'),
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
