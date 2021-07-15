import 'package:flutter/material.dart';
import 'package:tutorapp/models/user_model.dart';

class InheritedUserModel extends InheritedWidget {
  final UserModel userData;
  final Widget child;

  InheritedUserModel({
    Key? key,
    required this.userData,
    required this.child,
  }) : super(key: key, child: child);

  static InheritedUserModel of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedUserModel>()
        as InheritedUserModel);
  }

  @override
  bool updateShouldNotify(InheritedUserModel oldWidget) {
    return true;
  }
}
