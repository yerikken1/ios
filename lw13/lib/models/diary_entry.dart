class DiaryEntry {
  final String imagePath;
  final String caption;
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;

  const DiaryEntry({
    required this.imagePath,
    required this.caption,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'caption': caption,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'timestamp': timestamp.toIso8601String(),
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      imagePath: json['imagePath'] as String,
      caption: json['caption'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
