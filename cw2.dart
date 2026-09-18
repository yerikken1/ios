// 1.Create class Book
class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book(this.title, this.author, this.price, {this.isBorrowed = false});
}


// 2.Create class Library
class Library {
  List<Book> _books = [];

  // Add a book to the library
  void addBook(Book book) {
    _books.add(book);
  }

  // Get available books using .where()
  List<Book> getAvailableBooks() {
    return _books.where((book) => !book.isBorrowed).toList();
  }

  // Calculate total value using .fold()
  double getTotalValue() {
    return _books.fold(0, (sum, book) => sum + book.price);
  }
}