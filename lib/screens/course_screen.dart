import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';  // Ensure this is the correct path to your CourseCard widget.

class CourseScreen extends StatelessWidget {
  final List<Course> courses;

  CourseScreen({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Курсы'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseCard(
            course: courses[index],
            onPressed: () {
              // Navigate to the course detail screen when a course card is tapped.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(course: courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
