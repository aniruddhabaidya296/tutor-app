import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tutorapp/prothomPage.dart';

import '../studentfirstpage.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoInitial());

  @override
  Stream<PhotoState> mapEventToState(
    PhotoEvent event,
  ) async* {
    if (event is GetPhoto) {
      final photo = event.photo;
      final _firebaseStorage = FirebaseStorage.instance;
      var snapshot = await _firebaseStorage
          .ref()
          .child('Images/$currentUserId')
          .putFile(photo);
      profileDp = await snapshot.ref.getDownloadURL();
      yield PhotoSet(photo);
    }
  }
}
