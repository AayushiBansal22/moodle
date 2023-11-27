import 'package:flutter/material.dart';

class CourseIdModel extends ChangeNotifier {
  String _courseId = '';

  String get courseId => _courseId;

  void setCourseId(String courseId) {
    _courseId = courseId;
    notifyListeners();
  }
}
