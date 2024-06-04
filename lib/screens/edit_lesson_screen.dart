import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson.dart';

class EditLessonScreen extends StatefulWidget {
  final Lesson lesson;

  EditLessonScreen({required this.lesson});

  @override
  _EditLessonScreenState createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.lesson.title);
    _descriptionController = TextEditingController(text: widget.lesson.description);
  }

  Future<void> updateLesson(BuildContext context) async {
    final scaffoldContext = context;

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5001/api/Courses/UpdateLesson'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'lessonId': widget.lesson.lessonId,
          'title': _titleController.text,
          'isDelete': false, // Assuming you are not deleting the lesson in this context
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text('Урок успешно обновлен')),
        );
        Navigator.of(context).pop(true); // Close the edit screen and return true to indicate success
      } else {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении урока')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(content: Text('Ошибка при обновлении урока')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать урок'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название урока'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание урока'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateLesson(context),
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
