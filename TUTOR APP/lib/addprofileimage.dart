import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorapp/createprofilepage.dart';
import 'package:tutorapp/prothomPage.dart';

class AddProfileImage extends StatefulWidget {
  const AddProfileImage({Key? key}) : super(key: key);

  @override
  _AddProfileImageState createState() => _AddProfileImageState();
}

dynamic showProgressIndicator(bool enable) async {
  if (enable) {
    return CircularProgressIndicator(
      value: null,
      strokeWidth: 7.0,
    );
  } else
    return;
}

class _AddProfileImageState extends State<AddProfileImage> {
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
        var snapshot =
            await _firebaseStorage.ref().child('Images/').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          profileImageUrl = downloadUrl;
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
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text("UPLOAD IMAGE"),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
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
                    child: (profileImageUrl != '')
                        ? Image.network(profileImageUrl, fit: BoxFit.cover)
                        : Center(
                            child: FloatingActionButton(
                                child: const Icon(Icons.add),
                                backgroundColor: Colors.blue,
                                onPressed: () {
                                  uploadImage();
                                })))),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 17,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateProfilePage()),
                    );
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'VisbyRoundCF',
                        fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ))));
  }
}
