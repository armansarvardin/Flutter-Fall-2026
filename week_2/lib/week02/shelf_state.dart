import 'models.dart';

sealed class ShelfState {
  const ShelfState();
}

final class Empty extends ShelfState {
  const Empty();
}

final class Ready extends ShelfState {
  const Ready(this.books);

  final List<Book> books;
}

final class Broken extends ShelfState {
  const Broken(this.message);

  final String message;
}

String describe(ShelfState state) => switch (state) {
  Empty() => 'Shelf is empty',
  Ready(books: final books) => 'Shelf is ready with ${books.length} books',
  Broken(message: final message) => 'Shelf is broken: $message',
};

({int count, double avgPages}) statsOf(List<Book> books) => (
  count: books.length,
  avgPages: books.isEmpty
      ? 0.0
      : books.fold<int>(0, (sum, b) => sum + b.pages) / books.length,
);
