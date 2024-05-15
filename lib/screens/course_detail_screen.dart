import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/lesson_item.dart'; // Make sure this file is correctly created and imported

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  CourseDetailScreen({required this.course});

  @override  // Corrected here
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              course.imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                course.description,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Уроки',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            ...course.lessons.map((lesson) => LessonItem(lesson: lesson)).toList(),
          ],
        ),
      ),
    );
  }
}
