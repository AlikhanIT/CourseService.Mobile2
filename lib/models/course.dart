import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.lessons,
  });
}
