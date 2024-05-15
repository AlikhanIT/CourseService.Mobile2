import 'package:flutter/material.dart';
import 'models/lesson.dart';
import 'screens/course_screen.dart';
import 'screens/profile_screen.dart';
import 'models/user.dart';
import 'models/course.dart';
List<Course> allCourses = [
  Course(
    id: '1',
    title: 'Flutter для начинающих',
    description: 'Описание курса Flutter для начинающих',
    imageUrl: 'https://picsum.photos/500/300', // Add your image URL
    lessons: [
      Lesson(id: 'L1', title: 'Введение в Flutter', description: 'Основы Flutter и начало работы.'),
      Lesson(id: 'L2', title: 'Stateless Widgets', description: 'Изучение Stateless Widgets.'),
    ],
  ),
  Course(
    id: '2',
    title: 'Продвинутый Flutter',
    description: 'Описание продвинутого курса по Flutter',
    imageUrl: 'https://picsum.photos/500/300',
    lessons: [
      Lesson(id: 'L1', title: 'Stateful Widgets', description: 'Работа со Stateful Widgets.'),
      Lesson(id: 'L2', title: 'Управление состоянием', description: 'Методы управления состоянием в Flutter.'),
    ],
  ),
  Course(
    id: '6',
    title: 'Flutter для начинающих',
    description: 'Описание курса Flutter для начинающих',
    imageUrl: 'https://picsum.photos/500/300', // Add your image URL
    lessons: [
      Lesson(id: 'L1', title: 'Stateful Widgets', description: 'Работа со Stateful Widgets.'),
      Lesson(id: 'L2', title: 'Управление состоянием', description: 'Методы управления состоянием в Flutter.'),
    ],
  ),
  Course(
    id: '3',
    title: 'Flutter для начинающих',
    description: 'Описание курса Flutter для начинающих',
    imageUrl: 'https://picsum.photos/500/300', // Add your image URL
    lessons: [
      Lesson(id: 'L1', title: 'Stateful Widgets', description: 'Работа со Stateful Widgets.'),
      Lesson(id: 'L2', title: 'Управление состоянием', description: 'Методы управления состоянием в Flutter.'),
    ],
  ),
  Course(
    id: '4',
    title: 'Flutter для начинающих',
    description: 'Описание курса Flutter для начинающих',
    imageUrl: 'https://picsum.photos/500/300', // Add your image URL
    lessons: [
      Lesson(id: 'L1', title: 'Stateful Widgets', description: 'Работа со Stateful Widgets.'),
      Lesson(id: 'L2', title: 'Управление состоянием', description: 'Методы управления состоянием в Flutter.'),
    ],
  ),
];

List<Course> myCourses = [
  Course(
    id: '4',
    title: 'Flutter для начинающих',
    description: 'Описание курса Flutter для начинающих',
    imageUrl: 'https://picsum.photos/500/300', // Add your image URL
    lessons: [
      Lesson(id: 'L1', title: 'Stateful Widgets', description: 'Работа со Stateful Widgets.'),
      Lesson(id: 'L2', title: 'Управление состоянием', description: 'Методы управления состоянием в Flutter.'),
    ],
  )
];



class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      CourseScreen(courses: allCourses),
      CourseScreen(courses: myCourses),
      ProfileScreen(user: User(id: '1', name: 'Иван Иванов', email: 'ivan@example.com')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'All Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
