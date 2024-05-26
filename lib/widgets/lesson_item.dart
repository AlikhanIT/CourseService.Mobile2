import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../screens/lesson_detail_screen.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;

  LessonItem({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          lesson.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        subtitle: lesson.description.isNotEmpty
            ? Text(lesson.description)
            : Text('Без описания'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to the lesson detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonDetailScreen(lesson: lesson),
            ),
          );
        },
      ),
    );
  }
}
