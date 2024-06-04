import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/lesson.dart'; // Убедитесь, что модель Lesson импортирована
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class CourseScreen extends StatelessWidget {
  final List<Course> courses;
  final List<Course> myCourses;
  final bool isUserRegistered;
  final Future<void> Function() fetchCourses;
  final Future<void> Function() fetchMyCourses;

  CourseScreen({
    required this.courses,
    required this.myCourses,
    required this.isUserRegistered,
    required this.fetchCourses,
    required this.fetchMyCourses,
  });

  Future<List<Lesson>> fetchLessons(String courseId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/Courses/GetAllLessons/$courseId'));

    if (response.statusCode == 200) {
      final List<dynamic> lessonJson = json.decode(response.body);
      return lessonJson.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить уроки');
    }
  }

  Future<void> addNewCourse(BuildContext context) async {
    String courseName = '';
    final scaffoldContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый курс'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Введите название курса'),
            onChanged: (value) {
              courseName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (courseName.isNotEmpty) {
                  try {
                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:5156/api/v1/course/create-course/$courseName'),
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Курс успешно добавлен')),
                      );
                      await fetchCourses();
                      await fetchMyCourses();
                    } else {
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Ошибка при добавлении курса')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Ошибка при добавлении курса')),
                    );
                  }
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Курсы'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final role = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('Курсы'),
          ),
          body: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              final isInMyCourses = myCourses.any((myCourse) => myCourse.id == course.id);

              return CourseCard(
                course: course,
                onPressed: () async {
                  try {
                    final lessons = await fetchLessons(course.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(course: course, lessons: lessons),
                      ),
                    );
                  } catch (e) {
                    print('Не удалось загрузить уроки: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Не удалось загрузить уроки')),
                    );
                  }
                },
                isInMyCourses: isInMyCourses,
                fetchCourses: fetchCourses,
                fetchMyCourses: fetchMyCourses,
              );
            },
          ),
          floatingActionButton: role == 'user' && isUserRegistered
              ? FloatingActionButton(
            heroTag: 'uniqueAddCourseButton_${UniqueKey().toString()}', // Уникальный тег
            onPressed: () => addNewCourse(context),
            child: Icon(Icons.add),
          )
              : null,
        );
      },
    );
  }
}
