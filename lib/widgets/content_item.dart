class ContentItem {
  final String contentItemId;
  final String title;
  final String contentText;
  final String imageUrl;
  final String lessonId;
  final int order;
  final bool isDeleted;

  ContentItem({
    required this.contentItemId,
    required this.title,
    required this.contentText,
    required this.imageUrl,
    required this.lessonId,
    required this.order,
    required this.isDeleted,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      contentItemId: json['contentItemId'],
      title: json['title'],
      contentText: json['contentText'],
      imageUrl: json['imageUrl'],
      lessonId: json['lessonId'],
      order: json['order'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentItemId': contentItemId,
      'title': title,
      'contentText': contentText,
      'imageUrl': imageUrl,
      'lessonId': lessonId,
      'order': order,
      'isDeleted': isDeleted,
    };
  }
}
