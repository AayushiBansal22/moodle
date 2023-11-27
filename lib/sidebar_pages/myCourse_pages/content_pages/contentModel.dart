import 'package:cloud_firestore/cloud_firestore.dart';

class ContentModel {
  final String courseId;
  final String content;

  ContentModel({required this.courseId, required this.content});

  factory ContentModel.fromDocument(DocumentSnapshot doc) {
    return ContentModel(
      courseId: doc['cid'],
      content: doc['content'],
    );
  }
}
