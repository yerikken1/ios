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