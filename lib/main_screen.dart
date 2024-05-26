import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/course.dart';
import 'screens/course_screen.dart';
import 'screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Course> allCourses = [];
  List<Course> myCourses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/Courses/all-courses'));

    if (response.statusCode == 200) {
      final List<dynamic> courseListJson = json.decode(response.body);
      final List<Course> courses = courseListJson.map((json) => Course.fromJson(json)).toList();

      setState(() {
        allCourses = courses;
        // Дополнительно можно фильтровать или обрабатывать курсы для myCourses
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      CourseScreen(courses: allCourses),
      CourseScreen(courses: myCourses),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Курсы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Мои курсы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
