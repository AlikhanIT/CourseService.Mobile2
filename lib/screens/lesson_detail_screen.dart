import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/content_item.dart';
import '../models/comment.dart';
import '../models/rating.dart';

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
  final _commentController = TextEditingController();
  int _selectedStars = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
                itemCount: widget.contentItems.length,
                itemBuilder: (context, index) {
                  final contentItem = widget.contentItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(contentItem.contentText),
                      subtitle: contentItem.imageUrl.isNotEmpty
                          ? Image.network(
                        contentItem.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Не удалось загрузить изображение');
                        },
                      )
                          : Text('Нет изображения'),
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
                          starIndex < rating.stars
                              ? Icons.star
                              : Icons.star_border,
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
    );
  }
}
