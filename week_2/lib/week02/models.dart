class Author {
  const Author({required this.name, this.country});

  final String name;
  final String? country;

  @override
  String toString() {
    final place = country;
    if (place == null) return name;
    return '$name ($place)';
  }
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  const Genre(this.label);

  final String label;

  static Genre fromString(String? raw) => switch (raw) {
    'craft' => Genre.craft,
    'theory' => Genre.theory,
    _ => Genre.unknown,
  };
}

abstract class LibraryItem {
  const LibraryItem({required this.title, required this.year});

  final String title;
  final int year;

  String describe();

  bool get isOld => year < 2000;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrow: $title ($year)';
}

class Book extends LibraryItem with Borrowable {
  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  const Book.missing()
    : this(
        title: 'Untitled',
        year: 0,
        pages: 0,
        author: const Author(name: 'Unknown'),
        genre: Genre.unknown,
      );

  factory Book.fromJson(Map<String, dynamic> json) {
    final Object? rawTitle = json['title'];
    final Object? rawYear = json['year'];
    final Object? rawPages = json['pages'];
    final Object? rawAuthor = json['author'];
    final Object? rawCountry = json['country'];
    final Object? rawGenre = json['genre'];
    final Object? rawDescription = json['description'];

    return Book(
      title: rawTitle is String ? rawTitle : 'Untitled',
      year: rawYear is int ? rawYear : 0,
      pages: rawPages is int ? rawPages : 0,
      author: Author(
        name: rawAuthor is String ? rawAuthor : 'Unknown',
        country: rawCountry is String ? rawCountry : null,
      ),
      genre: Genre.fromString(rawGenre is String ? rawGenre : null),
      description: rawDescription is String ? rawDescription : null,
    );
  }

  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) => Book(
    title: title ?? this.title,
    year: year ?? this.year,
    pages: pages ?? this.pages,
    author: author ?? this.author,
    genre: genre ?? this.genre,
    description: description ?? this.description,
  );

  @override
  String describe() => '$title by ${author.name}, ${genre.label}, $pages pages';

  @override
  String toString() =>
      'Book($title, $year, ${pages}p, ${author.name}, ${genre.label})';
}

class Magazine extends LibraryItem {
  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  final int issue;

  @override
  String describe() => '$title, issue $issue ($year)';
}

class Ghost implements LibraryItem {
  const Ghost({this.title = 'Ghost entry', this.year = 0});

  @override
  final String title;

  @override
  final int year;

  @override
  bool get isOld => true;

  @override
  String describe() => '$title - a record nobody can find';
}
