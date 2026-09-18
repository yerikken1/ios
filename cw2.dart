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


// 3.Main Execution
void main() {
  // Create library
  Library library = Library();

  // Add sample books
  library.addBook(Book("Harry Potter", "J.K. Rowling", 20));
  library.addBook(Book("1984", "George Orwell", 15, isBorrowed: true));
  library.addBook(Book("The Hobbit", "J.R.R. Tolkien", 18));
  library.addBook(Book("Dune", "Frank Herbert", 25));

  // Print available books
  print("Available books:");
  for (var book in library.getAvailableBooks()) {
    print("${book.title} - ${book.author}");
  }

  // Print total collection value
  print("Total value: \$${library.getTotalValue()}");
}