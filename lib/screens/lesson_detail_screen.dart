import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  LessonDetailScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              "https://picsum.photos/500/300", // Mock URL for the lesson image
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Detailed information about the lesson here. You can expand this text to include various aspects of the lesson.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            // You can add more widgets here to display different types of content
          ],
        ),
      ),
    );
  }
}
