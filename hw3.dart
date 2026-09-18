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


// 4.Class ShoppingCart
class ShoppingCart {
  final List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double subtotal = _items.fold(0.0, (sum, item) => sum + item.price);
    return subtotal * (1 + taxRate);
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) => item.price <= maxPrice).toList();
  }

  void printReceipt() {
    print('--- SHOPPING CART RECEIPT ---');
    for (var item in _items) {
      print(item.getDetails());

      // Explicit cast resolves the compiler check directly
      if (item is Downloadable) {
        (item as Downloadable).download(item.title);
      }

      print('-----------------------------');
    }

    double total = calculateTotalWithTax();
    print('Total (incl. 12% tax): \$${total.toStringAsFixed(2)}');
  }
}


// Main execution test
void main() {
  var cart = ShoppingCart();

  var book1 = EBook(
    id: 'e1',
    title: 'Flutter Deep Dive',
    price: 19.99,
    fileSizeMB: 12.5,
    author: 'Jane Doe',
  );

  var audio1 = Audiobook(
    id: 'a1',
    title: 'Dart Mechanics',
    price: 29.99,
    durationHours: 8.5,
    narrator: 'John Smith',
  );

  cart.addItem(book1);
  cart.addItem(audio1);

  cart.printReceipt();
}