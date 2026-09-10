import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) => items.add(item);

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    final matches = items.whereType<Book>().where((b) => b.title == title);
    if (matches.isEmpty) return null;
    return matches.first;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  String descriptionOf(String title) {
    final book = findByTitle(title);
    if (book == null) return 'no such book';
    final text = book.description;
    if (text == null) return 'no description';
    return text;
  }

  List<Book> get books => items.whereType<Book>().toList();

  List<String> get allTitles => items.map((i) => i.title).toList();

  List<Book> get publishedAfter2010 =>
      books.where((b) => b.year > 2010).toList();

  double get averagePages => books.isEmpty
      ? 0.0
      : books.fold<int>(0, (sum, b) => sum + b.pages) / books.length;

  Map<String, int> get booksPerAuthor => books.fold<Map<String, int>>(
    <String, int>{},
    (acc, b) => acc..update(b.author.name, (n) => n + 1, ifAbsent: () => 1),
  );

  Set<String> get authorNames => books.map((b) => b.author.name).toSet();

  Set<Genre> get genres => books.map((b) => b.genre).toSet();

  List<String> get displayLines => [
    'CATALOGUE',
    for (final b in books) '${b.title} (${b.year})',
    ...books.map((b) => b.author.name),
    if (books.any((b) => b.pages == 0)) '(incomplete data)',
  ];

  String report() => _cachedReport ??= displayLines.join('\n');

  bool get reportIsCached => _cachedReport == null ? false : true;
}
