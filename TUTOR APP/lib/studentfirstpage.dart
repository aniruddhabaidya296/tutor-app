import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorapp/prothomPage.dart';
import 'dart:io';
import 'addprofileimage.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

// Student temp_student = new Student();
var profileDp;

class StudentFirstPage extends StatefulWidget {
  @override
  _StudentFirstPageState createState() => _StudentFirstPageState();
}

class Student extends Person {
  var school;
  var board;
  var std;

  Student(String name, String school, String board, double std, String id)
      : super(name, "Student", id) {
    this.school = school;
    this.board = board;
    this.std = std;
  }

  bool validator() {
    if ((this.name == '') ||
        (this.school == '') ||
        (this.board == '') ||
        (this.std == '')) {
      return false;
    } else
      return true;
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
            .child('Images/$currentUserId')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          profileDp = imageUrl;
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
    return GestureDetector(
        onTap: () {},
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              title: Text("GET STARTED"),
            ),
            body: Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width / 1.7,
                      height: MediaQuery.of(context).size.width / 1.7,
                      margin: EdgeInsets.only(
                          top: 30, bottom: 20, left: 20, right: 20),
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
                  Center(
                      child: FloatingActionButton(
                          child: const Icon(Icons.photo_camera),
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            uploadImage();
                          })),
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
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        onPressed: () {
                          Student temp_student = new Student(
                              _nameController.text,
                              _schoolController.text,
                              _boardController.text,
                              double.parse(_classController.text),
                              currentUserId);
                          print(
                              "======================$currentUserId==================");
                          _callCreateStudentApi(temp_student);
                          if (temp_student.validator()) {
                            flag = true;
                          }
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            ModalRoute.withName('/home'),
                          );
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
            )),
          );
        }));
  }
}
