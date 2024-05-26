import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/content_item.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;
  final List<ContentItem> contentItems;

  LessonDetailScreen({required this.lesson, required this.contentItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              lesson.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              lesson.description.isNotEmpty ? lesson.description : 'Без описания',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Text(
              'Content Items:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contentItems.length,
                itemBuilder: (context, index) {
                  final contentItem = contentItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(contentItem.contentText),
                      subtitle: contentItem.imageUrl.isNotEmpty
                          ? Image.network(contentItem.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Failed to load image');
                        },
                      )
                          : Text('No Image Available'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
