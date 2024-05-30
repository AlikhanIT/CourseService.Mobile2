import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';

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
        SnackBar(content: Text('Ошибка при добавлении курса в избранное')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        margin: EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.course.imageUrl.isNotEmpty)
              Image.network(
                widget.course.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.course.title,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: toggleFavorite,
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
