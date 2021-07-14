import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tutorapp/photoEditPage/edit_page.dart';
import 'package:tutorapp/routes/route_names.dart';
import '../homepage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(builder: (_) => HomePage());
      case routeEdit:
        return MaterialPageRoute(
            builder: (_) => EditPhotoPage(
                  image: settings.arguments as File,
                ));
      default:
        throw (e);
    }
  }
}
