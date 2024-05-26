import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../models/lesson.dart'; // Ensure Lesson model is imported
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class CourseScreen extends StatelessWidget {
  final List<Course> courses;

  CourseScreen({required this.courses});

  Future<List<Lesson>> fetchLessons(String courseId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/Courses/GetAllLessons/$courseId'));

    if (response.statusCode == 200) {
      final List<dynamic> lessonJson = json.decode(response.body);
      return lessonJson.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

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
            onPressed: () async {
              try {
                final lessons = await fetchLessons(courses[index].id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(course: courses[index], lessons: lessons),
                  ),
                );
              } catch (e) {
                print('Failed to load lessons: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load lessons')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
