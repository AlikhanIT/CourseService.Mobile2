class Lesson {
  final String lessonId;
  final String title;
  final String courseId;
  final String description;
  final bool isDelete;
  final List<dynamic> contentItems;

  Lesson({
    required this.lessonId,
    required this.title,
    required this.courseId,
    required this.description,
    required this.contentItems,
    this.isDelete = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      title: json['title'],
      courseId: json['courseId'],
      description: json['description'] ?? '',
      contentItems: json['contentItems'] as List<dynamic>,
      isDelete: json['isDelete'] ?? false,
    );
  }
}
