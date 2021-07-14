import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tutorapp/bloc/photo_bloc.dart';
import 'package:tutorapp/routes/route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPhotoPage extends StatefulWidget {
  final File image;

  const EditPhotoPage({required this.image});

  @override
  _EditPhotoPageState createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  late File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.image;
    if (imageFile != null) _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            hideBottomControls: true,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      imageFile = croppedFile;
      context.read<PhotoBloc>().add(GetPhoto(imageFile));
      Navigator.pop(context, routeHome);
    }
  }
}
