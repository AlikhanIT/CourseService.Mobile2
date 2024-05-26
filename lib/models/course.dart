import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['courseId'],
      title: json['courseName'],
      description: json['description'],
      imageUrl: 'https://picsum.photos/500/300', // Подставляем заглушку для URL изображения
      lessons: [], // Вы можете адаптировать это для включения уроков
    );
  }
}

