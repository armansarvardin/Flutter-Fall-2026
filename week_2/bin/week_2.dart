import 'package:week_2/week02/catalogue.dart';
import 'package:week_2/week02/data.dart';
import 'package:week_2/week02/models.dart';
import 'package:week_2/week02/shelf_state.dart';

void main() {
  final library = Library();
  for (final json in rawBooks) {
    library.add(Book.fromJson(json));
  }

  library.add(const Magazine(title: 'Dart Weekly', year: 2024, issue: 42));

  library.open();

  _section('OPENED');
  print('Opened at: ${library.openedAt}');

  _section('REPORT (single list literal)');
  print(library.report());

  _section('LEVEL 1 - classes');
  final clean = library.findByTitle('Clean Code');
  print('findByTitle Clean Code : $clean');
  print('isLong                 : ${clean?.isLong}');
  print('Book.missing()         : ${const Book.missing()}');
  print('copyWith(year: 2009)   : ${clean?.copyWith(year: 2009)}');
  print('Author.toString()      : ${clean?.author}');
  print('Genre.fromString(null) : ${Genre.fromString(null).label}');
  print('Genre.fromString(pop)  : ${Genre.fromString('pop').label}');

  _section('LEVEL 2 - hierarchy');
  for (final item in library.items) {
    print('${item.describe()}   [isOld: ${item.isOld}]');
  }
  final borrowables = library.items.whereType<Borrowable>().toList();
  print(
    'Borrowable items       : ${borrowables.length} of ${library.items.length}',
  );
  print('borrowLabel example    : ${borrowables.first.borrowLabel()}');
  const ghost = Ghost();
  print('Ghost (implements)     : ${ghost.describe()} [isOld: ${ghost.isOld}]');

  _section('LEVEL 3 - null safety');
  print('countryOf Clean Code     : ${library.countryOf('Clean Code')}');
  print('countryOf Design Patterns: ${library.countryOf('Design Patterns')}');
  print('countryOf Nonexistent    : ${library.countryOf('Nonexistent')}');
  print('descriptionOf Refactoring: ${library.descriptionOf('Refactoring')}');
  print('descriptionOf Clean Code : ${library.descriptionOf('Clean Code')}');
  print('findByTitle Nonexistent  : ${library.findByTitle('Nonexistent')}');
  library.report();
  print('report cached            : ${library.reportIsCached}');

  _section('LEVEL 4 - collections');
  print('All titles        : ${library.allTitles}');
  print(
    'After 2010        : ${library.publishedAfter2010.map((b) => b.title).toList()}',
  );
  print('Average pages     : ${library.averagePages.toStringAsFixed(1)}');
  print('Books per author  : ${library.booksPerAuthor}');
  print('Author names      : ${library.authorNames}');
  print('Genres present    : ${library.genres.map((g) => g.label).toList()}');

  _section('LEVEL 5 - Dart 3');
  final stats = statsOf(library.books);
  print('statsOf record    : $stats');
  print('  count           : ${stats.count}');
  print('  avgPages        : ${stats.avgPages.toStringAsFixed(1)}');
  print(describe(const Empty()));
  print(describe(Ready(library.books)));
  print(describe(const Broken('water damage on shelf 3')));
}

void _section(String title) {
  print('');
  print('--- $title ---');
}
