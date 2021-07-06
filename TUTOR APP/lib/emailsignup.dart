import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:student/homepage.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({Key? key}) : super(key: key);

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  void registerToFb() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      dbRef.child(result.user!.uid).set({
        "email": emailController.text,
        "age": ageController.text,
        "name": nameController.text
      }).then((res) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(uid: result.user!.uid)),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _formKey,
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Padding(
                padding: EdgeInsets.all(40),
                child: Image.asset("assets/tutorhub_logo.PNG"),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black38)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(color: Colors.black38)),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value != null) {
                      return 'Enter User Email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter User Name",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(color: Colors.black38)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(color: Colors.black38)),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value != null) {
                      return 'Enter User Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black38)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(color: Colors.black38)),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value != null) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
                child: TextFormField(
                  controller: ageController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter Age",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black38)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(color: Colors.black38)),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value != null) {
                      return 'Enter Age';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue)),
                onPressed: () {
                  // if (_formKey.currentState != null) {
                  // if (_formKey.currentState.validate()==true) {
                  registerToFb();
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => HomePage()),
                  //     ModalRoute.withName('/home'));
                  // }
                  // }
                },
                child: Text('Submit'),
              ),
            ]))));
  }
}
