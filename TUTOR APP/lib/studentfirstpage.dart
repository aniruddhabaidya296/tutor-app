import 'dart:convert';
import 'homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class StudentFirstPage extends StatefulWidget {
  @override
  _StudentFirstPageState createState() => _StudentFirstPageState();
}

class Student {
  var name;
  var school;
  var board;
  var std;
  var id;
  var uuid = Uuid();

  void _createStudent(String name, String school, String board, double std) {
    this.id = uuid.v1();
    this.name = name;
    this.school = school;
    this.board = board;
    this.std = std;
  }
}

class _StudentFirstPageState extends State<StudentFirstPage> {
  Future<http.Response> _callCreateStudentApi(Student student) {
    // print("CreateStudentApi called");
    return http.post(Uri.parse('http://192.168.1.100:8080/student/add'),
        body: jsonEncode(<String, String>{
          'id': student.id,
          'Name': student.name,
          'School': student.school,
          'Board': student.board,
          'Class': (student.std).round().toString()
        }));
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _boardController = TextEditingController();
  TextEditingController _classController = TextEditingController();

  Student temp_student = new Student();

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
    return GestureDetector(
        onTap: () {},
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              title: Text("STUDENT DATABASE"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('WELCOME',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'VisbyRoundCF',
                          fontWeight: FontWeight.bold)),
                  Padding(
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
                      child: TextFormField(
                        controller: _nameController,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'VisbyRoundCF'),
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
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
                      child: TextFormField(
                        controller: _schoolController,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'VisbyRoundCF'),
                        decoration: InputDecoration(
                            labelText: "School",
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'VisbyRoundCF'),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
                      child: TextFormField(
                        controller: _boardController,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          fontFamily: 'VisbyRoundCF',
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                            labelText: "Board",
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'VisbyRoundCF'),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
                      child: TextField(
                        controller: _classController,
                        cursorColor: Colors.black,
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'VisbyRoundCF'),

                        decoration: InputDecoration(
                            labelText: "Class",
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'VisbyRoundCF'),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        onPressed: () {
                          temp_student._createStudent(
                              _nameController.text,
                              _schoolController.text,
                              _boardController.text,
                              double.parse(_classController.text));
                          _callCreateStudentApi(temp_student);

                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomePage()),
                          //   ModalRoute.withName('/home'),
                          // );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.blue,
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'VisbyRoundCF',
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
