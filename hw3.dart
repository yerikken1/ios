// 1.Abstract Class MediaItem
abstract class MediaItem {
  final String id;
  final String title;
  final double price;

  MediaItem({
    required this.id,
    required this.title,
    required this.price,
  });

  String getDetails();
}


// 3.Mixin Downloadable
mixin Downloadable {
  void download(String title) {
    print('Downloading "$title"...');
  }
}


// 2&3.Subclass Audiobook
class Audiobook extends MediaItem with Downloadable {
  final double durationHours;
  final String narrator;

  Audiobook({
    required String id,
    required String title,
    required double price,
    required this.durationHours,
    required this.narrator,
  }) : super(id: id, title: title, price: price);

  @override
  String getDetails() {
    return 'Audiobook: "$title" by Narrator: $narrator | Duration: ${durationHours}hrs | Price: \$${price.toStringAsFixed(2)}';
  }
}


// 2&3.Subclass EBook
class EBook extends MediaItem with Downloadable {
  final double fileSizeMB;
  final String author;

  EBook({
    required String id,
    required String title,
    required double price,
    required this.fileSizeMB,
    required this.author,
  }) : super(id: id, title: title, price: price);

  @override
  String getDetails() {
    return 'EBook: "$title" by $author | Size: ${fileSizeMB}MB | Price: \$${price.toStringAsFixed(2)}';
  }
}