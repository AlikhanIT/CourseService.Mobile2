import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../models/lesson.dart';
import '../widgets/lesson_item.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  final List<Lesson> lessons;

  CourseDetailScreen({required this.course, required this.lessons});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late List<Lesson> lessons;

  @override
  void initState() {
    super.initState();
    lessons = widget.lessons;
  }

  Future<List<Lesson>> fetchLessons() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/Courses/GetAllLessons/${widget.course.id}'));

    if (response.statusCode == 200) {
      final List<dynamic> lessonJson = json.decode(response.body);
      return lessonJson.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить уроки');
    }
  }

  Future<void> addLesson(BuildContext context) async {
    String lessonTitle = '';
    final scaffoldContext = context; // Сохранение контекста для использования позже

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый урок'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Введите название урока'),
            onChanged: (value) {
              lessonTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (lessonTitle.isNotEmpty) {
                  try {
                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:5001/api/Courses/add-lesson'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'courseId': widget.course.id,
                        'title': lessonTitle,
                      }),
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Урок успешно добавлен')),
                      );
                      // Обновление уроков после успешного добавления
                      final updatedLessons = await fetchLessons();
                      setState(() {
                        lessons = updatedLessons;
                      });
                    } else {
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Ошибка при добавлении урока')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Ошибка при добавлении урока')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              widget.course.imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                widget.course.description,
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
            ...lessons.map((lesson) => LessonItem(lesson: lesson)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addLesson(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
