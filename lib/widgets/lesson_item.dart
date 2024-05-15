
import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../screens/lesson_detail_screen.dart';


class LessonItem extends StatelessWidget {
  final Lesson lesson;

  LessonItem({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson.title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(lesson.description),
      onTap: () {
        // Navigate to the lesson detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailScreen(lesson: lesson),
          ),
        );
      },
    );
  }
}
