class Rating {
  final String username;
  final int stars; // Assuming a rating out of 5
  final DateTime timestamp;

  Rating({
    required this.username,
    required this.stars,
    required this.timestamp,
  });
}
