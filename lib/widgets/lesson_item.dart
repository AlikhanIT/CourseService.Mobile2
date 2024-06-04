import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/lesson_detail_screen.dart';
import '../screens/edit_lesson_screen.dart';
import 'content_item.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;

  LessonItem({required this.lesson});

  Future<List<ContentItem>> fetchContentItems(String lessonId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/Courses/GetAllContentItems/$lessonId'));

    if (response.statusCode == 200) {
      final List<dynamic> contentJson = json.decode(response.body);
      return contentJson.map((json) => ContentItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load content items');
    }
  }

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditLessonScreen(lesson: lesson),
                  ),
                );
              },
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
        onTap: () async {
          try {
            final contentItems = await fetchContentItems(lesson.lessonId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonDetailScreen(lesson: lesson, contentItems: contentItems),
              ),
            );
          } catch (e) {
            print('Failed to load content items: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load content items')),
            );
          }
        },
      ),
    );
  }
}
