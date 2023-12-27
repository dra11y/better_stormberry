// ignore_for_file: annotate_overrides

part of 'book.dart';

extension BookRepositories on PgDatabase {
  BookRepository get books => BookRepository._(this);
}

abstract class BookRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<BookInsertRequest>,
        ModelRepositoryUpdate<BookUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory BookRepository._(PgDatabase db) = _BookRepository;

  Future<BookView?> queryBook(String id);
  Future<List<BookView>> queryBooks([QueryParams? params]);
}

class _BookRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, BookInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, BookUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements BookRepository {
  _BookRepository(super.db) : super(tableName: 'books', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<BookView?> queryBook(String id) {
    return queryOne(id, BookViewQueryable());
  }

  @override
  Future<List<BookView>> queryBooks([QueryParams? params]) {
    return queryMany(BookViewQueryable(), params);
  }

  @override
  Future<void> insert(List<BookInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "books" ( "id", "title", "author_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.title)}:text, ${values.add(r.authorId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<BookUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "books"\n'
      'SET "title" = COALESCE(UPDATED."title", "books"."title"), "author_id" = COALESCE(UPDATED."author_id", "books"."author_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.title)}:text::text, ${values.add(r.authorId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "title", "author_id")\n'
      'WHERE "books"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class BookInsertRequest {
  BookInsertRequest({
    required this.id,
    required this.title,
    required this.authorId,
  });

  final String id;
  final String title;
  final String authorId;
}

class BookUpdateRequest {
  BookUpdateRequest({
    required this.id,
    this.title,
    this.authorId,
  });

  final String id;
  final String? title;
  final String? authorId;
}

class BookViewQueryable extends KeyedViewQueryable<BookView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "books".*, row_to_json("author".*) as "author"'
      'FROM "books"'
      'LEFT JOIN (${AuthorViewQueryable().query}) "author"'
      'ON "books"."author_id" = "author"."id"';

  @override
  String get tableAlias => 'books';

  @override
  BookView decode(TypedMap map) => BookView(
      id: map.get('id'),
      title: map.get('title'),
      author: map.get('author', AuthorViewQueryable().decoder));
}

class BookView {
  BookView({
    required this.id,
    required this.title,
    required this.author,
  });

  final String id;
  final String title;
  final AuthorView author;
}
