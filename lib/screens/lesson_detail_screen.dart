import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/lesson.dart';
import '../models/content_item.dart';
import '../models/comment.dart';
import '../models/rating.dart';
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

  Future<void> _addContentItem(String contentText) async {
    final newContentItem = ContentItem(
      contentItemId: _uuid.v4(),
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
    String contentText = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый контент'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Введите текст контента'),
            onChanged: (value) {
              contentText = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (contentText.isNotEmpty) {
                  _addContentItem(contentText);
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
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.lesson.description.isNotEmpty ? widget.lesson.description : 'Без описания',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'Элементы содержания:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _contentItems.length,
                itemBuilder: (context, index) {
                  final contentItem = _contentItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(contentItem.contentText),
                      subtitle: contentItem.imageUrl.isNotEmpty && contentItem.imageUrl.length >100
                          ? Image.memory(
                        base64Decode(contentItem.imageUrl),
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Не удалось загрузить изображение');
                        },
                      )
                          : Text('Нет изображения'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
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
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.0),
              Text(
                'Комментарии:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return ListTile(
                    title: Text(comment.username),
                    subtitle: Text(comment.content),
                    trailing: Text(
                      '${comment.timestamp.hour}:${comment.timestamp.minute}',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Добавить комментарий',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Text(
                'Оценка:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedStars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty && _selectedStars > 0) {
                    _addCommentAndRating(_commentController.text, _selectedStars);
                  }
                },
                child: Text('Отправить комментарий и оценку'),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _ratings.length,
                itemBuilder: (context, index) {
                  final rating = _ratings[index];
                  return ListTile(
                    title: Text(rating.username),
                    subtitle: Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < rating.stars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16.0,
                        );
                      }),
                    ),
                    trailing: Text(
                      '${rating.timestamp.hour}:${rating.timestamp.minute}',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContentDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
