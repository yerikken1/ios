
import 'package:flutter/material.dart';

void main() {
  runApp(const BookStoreApp());
}

const Color sage = Color(0xFF9CAF88);
const Color darkGreen = Color(0xFF435744);
const Color cream = Color(0xFFF7F3EA);
const Color beige = Color(0xFFE8DFCE);
const Color white = Color(0xFFFFFEFA);

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book heaven',
      theme: ThemeData(
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: sage,
          primary: darkGreen,
          surface: cream,
        ),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: darkGreen,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String category;
  final String description;
  final double price;
  final String emoji;
  final Color coverColor;

  const Book({
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.price,
    required this.emoji,
    required this.coverColor,
  });
}

const List<Book> books = [
  Book(
    title: 'Pride and prejudice',
    author: 'Jane Austen',
    category: 'Classic',
    description:
        'A timeless story of love, family, and the importance of looking beyond first impressions.',
    price: 4500,
    emoji: '🌿',
    coverColor: Color(0xFFD9E0CD),
  ),
  Book(
    title: 'Little women',
    author: 'Louisa May Alcott',
    category: 'Fiction',
    description:
        'Follow the lives of four sisters as they discover love, ambition, and the meaning of home.',
    price: 5200,
    emoji: '🌸',
    coverColor: Color(0xFFEAD8CB),
  ),
  Book(
    title: 'The great gatsby',
    author: 'F. Scott Fitzgerald',
    category: 'Classic',
    description:
        'A beautiful and bittersweet portrait of dreams, wealth, and life in the jazz age.',
    price: 4800,
    emoji: '✨',
    coverColor: Color(0xFFE9DDB8),
  ),
  Book(
    title: 'The secret garden',
    author: 'Frances Hodgson Burnett',
    category: 'Fiction',
    description:
        'An enchanting story about friendship, healing, and a hidden garden that changes everything.',
    price: 3900,
    emoji: '🌷',
    coverColor: Color(0xFFC8D8C1),
  ),
  Book(
    title: 'Atomic habits',
    author: 'James Clear',
    category: 'Self-growth',
    description:
        'A practical guide to building better habits through small, consistent changes.',
    price: 6500,
    emoji: '🍃',
    coverColor: Color(0xFFD8DCCB),
  ),
  Book(
    title: 'The little prince',
    author: 'Antoine de Saint-Exupéry',
    category: 'Fantasy',
    description:
        'A poetic journey that reminds us what matters most in life, love, and friendship.',
    price: 3500,
    emoji: '⭐',
    coverColor: Color(0xFFE8DAB8),
  ),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final Set<String> favoriteTitles = {};

  void toggleFavorite(Book book) {
    setState(() {
      if (favoriteTitles.contains(book.title)) {
        favoriteTitles.remove(book.title);
      } else {
        favoriteTitles.add(book.title);
      }
    });
  }

  void openBook(Book book) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookDetailScreen(
          book: book,
          isFavorite: favoriteTitles.contains(book.title),
          onFavorite: () => toggleFavorite(book),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onBookTap: openBook,
        favoriteTitles: favoriteTitles,
        onFavorite: toggleFavorite,
        onSeeAll: () => setState(() => selectedIndex = 1),
      ),
      ExplorePage(
        onBookTap: openBook,
        favoriteTitles: favoriteTitles,
        onFavorite: toggleFavorite,
      ),
      FavoritesPage(
        favoriteTitles: favoriteTitles,
        onBookTap: openBook,
        onFavorite: toggleFavorite,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: white,
          border: Border(
            top: BorderSide(color: beige, width: 0.7),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: white,
          selectedItemColor: darkGreen,
          unselectedItemColor: const Color(0xFFAAA99E),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final ValueChanged<Book> onBookTap;
  final Set<String> favoriteTitles;
  final ValueChanged<Book> onFavorite;
  final VoidCallback onSeeAll;

  const HomePage({
    super.key,
    required this.onBookTap,
    required this.favoriteTitles,
    required this.onFavorite,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: beige,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: darkGreen,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book heaven',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    Text(
                      'a little corner for book lovers',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.notifications_none_rounded,
                color: darkGreen,
                size: 27,
              ),
            ],
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E8D9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'your next chapter',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: darkGreen,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Find your\nnext favorite\nbook.',
                        style: TextStyle(
                          fontSize: 29,
                          height: 1.15,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Slow down and get lost in a good story.',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          height: 1.5,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 17),
                      ElevatedButton(
                        onPressed: onSeeAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          foregroundColor: white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          'Explore books',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      '📚',
                      style: TextStyle(fontSize: 91),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeading(
            title: 'Browse categories',
            subtitle: 'a genre for every mood',
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 43,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryChip(label: 'All books', selected: true),
                CategoryChip(label: 'Classics'),
                CategoryChip(label: 'Fiction'),
                CategoryChip(label: 'Fantasy'),
                CategoryChip(label: 'Self-growth'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SectionHeading(
            title: 'Popular books',
            subtitle: 'stories readers adore',
            action: 'See all',
            onAction: onSeeAll,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 290,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, _) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                final book = books[index];
                return SizedBox(
                  width: 155,
                  child: BookCard(
                    book: book,
                    isFavorite: favoriteTitles.contains(book.title),
                    onTap: () => onBookTap(book),
                    onFavorite: () => onFavorite(book),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: beige.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.spa_outlined, size: 31, color: darkGreen),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'a moment just for you',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Tea, a cozy blanket, and a beautiful book.',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 12,
                color: darkGreen,
              ),
            ),
          ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 9),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
      decoration: BoxDecoration(
        color: selected ? darkGreen : white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? darkGreen : beige,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 12,
          color: selected ? white : darkGreen,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const BookCard({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: book.coverColor,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_stories_rounded,
                          size: 31,
                          color: darkGreen,
                        ),
                        const SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            book.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          book.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 9,
                  right: 9,
                  child: Material(
                    color: white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onFavorite,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? Colors.redAccent : darkGreen,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Arial',
              color: Colors.black54,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${book.price.toStringAsFixed(0)} ₸',
            style: const TextStyle(
              fontFamily: 'Arial',
              color: darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class ExplorePage extends StatefulWidget {
  final ValueChanged<Book> onBookTap;
  final Set<String> favoriteTitles;
  final ValueChanged<Book> onFavorite;

  const ExplorePage({
    super.key,
    required this.onBookTap,
    required this.favoriteTitles,
    required this.onFavorite,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String query = '';
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final matchesQuery =
          book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());

      final matchesCategory =
          category == 'All' || book.category == category;

      return matchesQuery && matchesCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(22, 22, 22, 6),
          child: Text(
            'Explore books',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            'find a story that feels like you',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'Search books or authors...',
              hintStyle: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 13,
              ),
              prefixIcon: const Icon(Icons.search, color: darkGreen),
              filled: true,
              fillColor: white,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 42,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              'All',
              'Classic',
              'Fiction',
              'Fantasy',
              'Self-growth',
            ].map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    item,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 11,
                      color: category == item ? white : darkGreen,
                    ),
                  ),
                  selected: category == item,
                  selectedColor: darkGreen,
                  backgroundColor: white,
                  side: BorderSide.none,
                  onSelected: (_) => setState(() => category = item),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: filteredBooks.isEmpty
              ? const Center(
                  child: Text(
                    'No books found. Try another search.',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      color: darkGreen,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 17,
                    childAspectRatio: 0.59,
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return BookCard(
                      book: book,
                      isFavorite:
                          widget.favoriteTitles.contains(book.title),
                      onTap: () => widget.onBookTap(book),
                      onFavorite: () => widget.onFavorite(book),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final Set<String> favoriteTitles;
  final ValueChanged<Book> onBookTap;
  final ValueChanged<Book> onFavorite;

  const FavoritesPage({
    super.key,
    required this.favoriteTitles,
    required this.onBookTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteBooks = books
        .where((book) => favoriteTitles.contains(book.title))
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My favorites',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'your little collection of lovely stories',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: favoriteBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(23),
                          decoration: const BoxDecoration(
                            color: beige,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            size: 42,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No favorites yet',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap the heart on a book you love.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    itemCount: favoriteBooks.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.59,
                    ),
                    itemBuilder: (context, index) {
                      final book = favoriteBooks[index];
                      return BookCard(
                        book: book,
                        isFavorite: true,
                        onTap: () => onBookTap(book),
                        onFavorite: () => onFavorite(book),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'your personal reading corner',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 27),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E8D9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: darkGreen,
                    size: 53,
                  ),
                ),
                const SizedBox(height: 17),
                const Text(
                  'Aydana Yerkengazina',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'aidana.erkengazina@narxoz.kz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'book lover 🌿',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: darkGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Reading space',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 15),
          const ProfileOption(
            icon: Icons.menu_book_rounded,
            title: 'My reading list',
            subtitle: 'Books waiting for you',
          ),
          const ProfileOption(
            icon: Icons.bookmark_border_rounded,
            title: 'Saved books',
            subtitle: 'Stories to come back to',
          ),
          const ProfileOption(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Stay updated with new books',
          ),
          const ProfileOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Personalize your experience',
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'made with love for book lovers',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 11,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: beige),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EDE2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: darkGreen, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: sage,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title coming soon'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: darkGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book details',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: onFavorite,
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? Colors.redAccent : darkGreen,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 15, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 320,
                width: 230,
                decoration: BoxDecoration(
                  color: book.coverColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.12),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      size: 45,
                      color: darkGreen,
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      book.emoji,
                      style: const TextStyle(fontSize: 35),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        book.author,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 13,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE3E8D9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                book.category,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  color: darkGreen,
                ),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 29,
                height: 1.2,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'by ${book.author}',
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'About this book',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              book.description,
              style: const TextStyle(
                fontFamily: 'Arial',
                height: 1.7,
                fontSize: 14,
                color: Color(0xFF66685E),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: beige),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    color: darkGreen,
                    size: 25,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Book price',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  Text(
                    '${book.price.toStringAsFixed(0)} ₸',
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton.icon(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                label: Text(
                  isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}