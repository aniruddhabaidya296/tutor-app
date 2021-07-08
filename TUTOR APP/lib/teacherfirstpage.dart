import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'homepage.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class TeacherFirstPage extends StatefulWidget {
  const TeacherFirstPage({Key? key}) : super(key: key);

  @override
  _TeacherFirstPageState createState() => _TeacherFirstPageState();
}

class Teacher {
  var name;
  var institution;
  var experience;
  var subject;
  var board;
  var std;
  var id;
  var medium;
  var uuid = Uuid();

  void _createTeacher(String name, String institution, String experience,
      String subject, String board, String std, String medium) {
    this.id = uuid.v1();
    this.name = name;
    this.institution = institution;
    this.experience = experience;
    this.subject = subject;
    this.board = board;
    this.std = std;
    this.medium = medium;
  }
}

class _TeacherFirstPageState extends State<TeacherFirstPage> {
  Future<http.Response> _callCreateTeacherApi(Teacher teacher) {
    // print("CreateteacherApi called");
    return http.post(Uri.parse('http://192.168.1.100:8080/teacher/add'),
        body: jsonEncode(<String, String>{
          'id': teacher.id,
          'Name': teacher.name,
          'School': teacher.institution,
          'Experience': teacher.experience,
          'Subject': teacher.subject,
          'Board': teacher.board,
          'Class': teacher.std,
          'Interface': teacher.medium
        }));
  }

  Teacher temp_teacher = new Teacher();
  TextEditingController _schoolNameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _boardController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  var _interfacevalue;

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
              title: Text("GET STARTED"),
            ),
            // resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 50, right: 50, bottom: 10, top: 50),
                      child: Text('WELCOME',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'VisbyRoundCF',
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              // hintText: "Name",
                              alignLabelWithHint: true,
                              labelText: "Name",
                              hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontFamily: 'VisbyRoundCF'),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                // borderRadius: BorderRadius.circular(20),
                                // gapPadding: 20
                              )),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: TextFormField(
                          controller: _schoolNameController,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'VisbyRoundCF',
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "School or Institution (if any):",
                              hintStyle: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  color: Colors.black38),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: TextFormField(
                            controller: _experienceController,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontFamily: 'VisbyRoundCF',
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                                labelText: "Experience(in years)",
                                hintStyle: TextStyle(
                                    fontFamily: 'VisbyRoundCF',
                                    color: Colors.black38),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ])),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: TextFormField(
                          controller: _subjectController,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'VisbyRoundCF',
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "Subject(s)",
                              hintStyle: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  color: Colors.black38),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: TextFormField(
                          controller: _boardController,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'VisbyRoundCF',
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "Board(s)",
                              hintStyle: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  color: Colors.black38),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: TextFormField(
                          controller: _classController,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'VisbyRoundCF',
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              labelText: "Classes (e.g. 9 to 12)",
                              hintStyle: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  color: Colors.black38),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 10),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: const Text(
                                'Online',
                                style: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  fontSize: 20,
                                ),
                              ),
                              leading: Radio<String>(
                                value: "Online",
                                groupValue: _interfacevalue,
                                onChanged: (String? value) {
                                  setState(() {
                                    _interfacevalue = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                'Offline',
                                style: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  fontSize: 20,
                                ),
                              ),
                              leading: Radio<String>(
                                value: "Offline",
                                groupValue: _interfacevalue,
                                onChanged: (String? value) {
                                  setState(() {
                                    _interfacevalue = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                'Both',
                                style: TextStyle(
                                  fontFamily: 'VisbyRoundCF',
                                  fontSize: 20,
                                ),
                              ),
                              leading: Radio<String>(
                                value: "Both",
                                groupValue: _interfacevalue,
                                onChanged: (String? value) {
                                  setState(() {
                                    _interfacevalue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 1.3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            temp_teacher._createTeacher(
                                _schoolNameController.text,
                                _nameController.text,
                                _experienceController.text,
                                _subjectController.text,
                                _boardController.text,
                                _classController.text,
                                _interfacevalue.toString());
                            _callCreateTeacherApi(temp_teacher);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              ModalRoute.withName('/home'),
                            );
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'VisbyRoundCF',
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
