class ContentItem {
  final String contentItemId;
  final String lessonId;
  final String contentText;
  final String imageUrl;
  final int order;

  ContentItem({
    required this.contentItemId,
    required this.lessonId,
    required this.contentText,
    required this.imageUrl,
    required this.order,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      contentItemId: json['contentItemId'],
      lessonId: json['lessonId'],
      contentText: json['contentText'],
      imageUrl: json['imageUrl'],
      order: json['order'],
    );
  }
}
