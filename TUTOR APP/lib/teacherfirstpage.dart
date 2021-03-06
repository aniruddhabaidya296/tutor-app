import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorapp/prothomPage.dart';
import 'package:uuid/uuid.dart';
import 'addprofileimage.dart';
import 'homepage.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'main.dart';
import 'studentfirstpage.dart';

String teacherId = uid.v4();
Uuid uid = new Uuid();

class TeacherFirstPage extends StatefulWidget {
  const TeacherFirstPage({Key? key}) : super(key: key);

  @override
  _TeacherFirstPageState createState() => _TeacherFirstPageState();
}

class Teacher extends Person {
  var institution;
  var experience;
  var subject;
  var board;
  var std;
  var medium;

  Teacher(String name, String institution, String experience, String subject,
      String board, String std, String medium, String id)
      : super(name, "Teacher", id) {
    this.name = name;
    this.institution = institution;
    this.experience = experience;
    this.subject = subject;
    this.board = board;
    this.std = std;
    this.medium = medium;
  }

  bool validator() {
    if ((this.name == '') ||
        (this.institution == '') ||
        (this.experience == '') ||
        (this.subject == '') ||
        (this.board == '') ||
        (this.std == '') ||
        (this.medium == '')) {
      return false;
    } else
      return true;
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

  String imageUrl = '';
  String profileImageUrl = '';

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('Images/$teacherId')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          profileDp = downloadUrl;
          WidgetsBinding.instance!.addPostFrameCallback((_) => () async {
                try {
                  profileDp = await storage
                      .ref()
                      .child('Images/$currentUserId')
                      .getDownloadURL();
                  print(profileDp);
                } catch (e) {
                  profileDp = await storage
                      .ref()
                      .child('Images/placeholder.png')
                      .getDownloadURL();
                  print("Check if image exists: $e");
                }
              });
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: Builder(builder: (context) {
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
                  padding:
                      EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 50),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 1.7,
                      height: MediaQuery.of(context).size.width / 1.7,
                      margin: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        // border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                          child: Image.network(profileDp, fit: BoxFit.cover))),
                ),
                Center(
                    child: FloatingActionButton(
                        child: const Icon(Icons.add),
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          uploadImage();
                        })),
                Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                        Teacher temp_teacher = new Teacher(
                            _schoolNameController.text,
                            _nameController.text,
                            _experienceController.text,
                            _subjectController.text,
                            _boardController.text,
                            _classController.text,
                            _interfacevalue.toString(),
                            currentUserId);
                        print(
                            "======================$currentUserId==================");
                        _callCreateTeacherApi(temp_teacher);
                        // if (temp_teacher.validator()) {
                        //   flag = true;
                        // }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
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
