import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/lesson.dart';
import '../models/comment.dart';
import '../models/rating.dart';
import '../widgets/content_item.dart';
import 'edit_content_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final List<ContentItem> contentItems;

  LessonDetailScreen({required this.lesson, required this.contentItems});

  @override
  _LessonDetailScreenState createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final List<Comment> _comments = [];
  final List<Rating> _ratings = [];
  late List<ContentItem> _contentItems;
  final _commentController = TextEditingController();
  int _selectedStars = 0;
  final _uuid = Uuid();

  String userRole = 'user'; // Example role, replace with actual role management

  @override
  void initState() {
    super.initState();
    _contentItems = widget.contentItems;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchContentItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/api/Courses/GetAllContentItems/${widget.lesson.lessonId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> contentJson = json.decode(response.body);
        setState(() {
          _contentItems = contentJson.map((json) => ContentItem.fromJson(json)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось загрузить контент урока')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при загрузке контента урока: $e')),
      );
    }
  }

  void _addCommentAndRating(String content, int stars) {
    final newComment = Comment(
      username: "Пользователь", // Default username
      content: content,
      timestamp: DateTime.now(),
    );

    final newRating = Rating(
      username: "Пользователь", // Default username
      stars: stars,
      timestamp: DateTime.now(),
    );

    setState(() {
      _comments.add(newComment);
      _ratings.add(newRating);
    });

    _commentController.clear();
    setState(() {
      _selectedStars = 0; // Reset stars
    });
  }

  Future<void> _addContentItem(String title, String contentText) async {
    final newContentItem = ContentItem(
      contentItemId: _uuid.v4(),
      title: title,
      contentText: contentText,
      imageUrl: '', // Assuming no image for simplicity
      lessonId: widget.lesson.lessonId,
      order: _contentItems.length + 1,
      isDeleted: false,
    );

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/api/Courses/AddContentToLesson'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'lessonId': newContentItem.lessonId,
        'title': newContentItem.title,
        'contentText': newContentItem.contentText,
        'imageUrl': newContentItem.imageUrl,
        'order': newContentItem.order,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _contentItems.add(newContentItem);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Контент успешно добавлен')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении контента')),
      );
    }
  }

  Future<void> _showAddContentDialog(BuildContext context) async {
    String title = '';
    String contentText = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый контент'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Введите заголовок контента'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Введите текст контента'),
                onChanged: (value) {
                  contentText = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title.isNotEmpty && contentText.isNotEmpty) {
                  _addContentItem(title, contentText);
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContentItemCard(ContentItem contentItem) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contentItem.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            if (contentItem.imageUrl.isNotEmpty && contentItem.imageUrl.length > 100)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.memory(
                  base64Decode(contentItem.imageUrl),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Не удалось загрузить изображение');
                  },
                ),
              ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.center,
              child: Text(
                contentItem.contentText,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            if (userRole == 'user')
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditContentScreen(contentItem: contentItem),
                        ),
                      ).then((_) {
                        _fetchContentItems(); // Refresh the content items after editing
                      });
                    },
                    icon: Icon(Icons.edit, size: 18),
                    label: Text("Редактировать"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.lesson.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.lesson.description.isNotEmpty ? widget.lesson.description : 'Без описания',
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
              SizedBox(height: 24.0),
              Text(
                'Элементы содержания:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _contentItems.length,
                itemBuilder: (context, index) {
                  final contentItem = _contentItems[index];
                  return _buildContentItemCard(contentItem);
                },
              ),
              SizedBox(height: 24.0),
              Text(
                'Комментарии и оценки:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  final rating = _ratings[index];

                  return ListTile(
                    title: Text(
                      comment.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.content),
                        SizedBox(height: 8.0),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star,
                              color: starIndex < rating.stars ? Colors.amber : Colors.grey,
                              size: 20.0,
                            );
                          }),
                        ),
                      ],
                    ),
                    trailing: Text(
                      comment.timestamp.toString(),
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              if (userRole == 'user')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(hintText: 'Введите комментарий'),
                    ),
                    Row(
                      children: [
                        Text('Оцените урок:'),
                        SizedBox(width: 8.0),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: index < _selectedStars ? Colors.amber : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedStars = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final comment = _commentController.text;
                        if (comment.isNotEmpty && _selectedStars > 0) {
                          _addCommentAndRating(comment, _selectedStars);
                        }
                      },
                      child: Text('Добавить комментарий и оценку'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: userRole == 'user'
          ? FloatingActionButton(
        onPressed: () => _showAddContentDialog(context),
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}
