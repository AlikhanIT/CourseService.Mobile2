import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../screens/edit_course_screen.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onPressed;
  final bool isInMyCourses;
  final Future<void> Function() fetchCourses;
  final Future<void> Function() fetchMyCourses;

  CourseCard({
    required this.course,
    required this.onPressed,
    required this.isInMyCourses,
    required this.fetchCourses,
    required this.fetchMyCourses,
  });

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isInMyCourses;
  }

  Future<void> toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: Пользователь не авторизован')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/api/Courses/add-course/$userId/${widget.course.id}'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        isFavorite = !isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isFavorite ? 'Курс успешно добавлен в избранное' : 'Курс успешно удален из избранного')),
      );
      await widget.fetchCourses();
      await widget.fetchMyCourses();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении/удалении курса в избранное')),
      );
    }
  }

  bool _isBase64(String str) {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/=]+\Z');
    return base64Pattern.hasMatch(str) && str.length % 4 == 0;
  }

  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    bool isBase64Image = widget.course.imageUrl.isNotEmpty && _isBase64(widget.course.imageUrl);
    bool isValidUrl = widget.course.imageUrl.isNotEmpty && _isValidUrl(widget.course.imageUrl);

    print('isBase64Image: $isBase64Image');
    print('isValidUrl: $isValidUrl');

    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        margin: EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isBase64Image)
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.memory(
                  base64Decode(widget.course.imageUrl),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else if (isValidUrl)
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  widget.course.imageUrl,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox.shrink();
                  },
                ),
              )
            else
              SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.course.title,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: toggleFavorite,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCourseScreen(
                            courseId: widget.course.id,
                            fetchCourses: widget.fetchCourses,
                            fetchMyCourses: widget.fetchMyCourses,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.course.description,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
