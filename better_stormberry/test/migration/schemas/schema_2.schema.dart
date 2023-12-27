// ignore_for_file: annotate_overrides

part of 'schema_2.dart';

extension Schema2Repositories on Database {
  AuthorRepository get authors => AuthorRepository._(this);
  BookRepository get books => BookRepository._(this);
}

abstract class AuthorRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<AuthorInsertRequest>,
        ModelRepositoryUpdate<AuthorUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory AuthorRepository._(Database db) = _AuthorRepository;

  Future<AuthorView?> queryAuthor(String id);
  Future<List<AuthorView>> queryAuthors([QueryParams? params]);
}

class _AuthorRepository extends BaseRepository
    with
        RepositoryInsertMixin<AuthorInsertRequest>,
        RepositoryUpdateMixin<AuthorUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements AuthorRepository {
  _AuthorRepository(super.db) : super(tableName: 'authors', keyName: 'id');

  @override
  Future<AuthorView?> queryAuthor(String id) {
    return queryOne(id, AuthorViewQueryable());
  }

  @override
  Future<List<AuthorView>> queryAuthors([QueryParams? params]) {
    return queryMany(AuthorViewQueryable(), params);
  }

  @override
  Future<void> insert(List<AuthorInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "authors" ( "id", "name" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.name)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<AuthorUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "authors"\n'
      'SET "name" = COALESCE(UPDATED."name", "authors"."name")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.name)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "name")\n'
      'WHERE "authors"."id" = UPDATED."id"',
      values.values,
    );
  }
}

abstract class BookRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<BookInsertRequest>,
        ModelRepositoryUpdate<BookUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory BookRepository._(Database db) = _BookRepository;

  Future<BookView?> queryBook(int id);
  Future<List<BookView>> queryBooks([QueryParams? params]);
}

class _BookRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<BookInsertRequest>,
        RepositoryUpdateMixin<BookUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements BookRepository {
  _BookRepository(super.db) : super(tableName: 'books', keyName: 'id');

  @override
  Future<BookView?> queryBook(int id) {
    return queryOne(id, BookViewQueryable());
  }

  @override
  Future<List<BookView>> queryBooks([QueryParams? params]) {
    return queryMany(BookViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<BookInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.query(
      'INSERT INTO "books" ( "title", "is_best_selling", "rating", "author_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.title)}:text, ${values.add(r.isBestSelling)}:boolean, ${values.add(r.rating)}:int8, ${values.add(r.authorId)}:text )').join(', ')}\n'
      'RETURNING "id"',
      values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<BookUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "books"\n'
      'SET "title" = COALESCE(UPDATED."title", "books"."title"), "is_best_selling" = COALESCE(UPDATED."is_best_selling", "books"."is_best_selling"), "rating" = COALESCE(UPDATED."rating", "books"."rating"), "author_id" = COALESCE(UPDATED."author_id", "books"."author_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.title)}:text::text, ${values.add(r.isBestSelling)}:boolean::boolean, ${values.add(r.rating)}:int8::int8, ${values.add(r.authorId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "title", "is_best_selling", "rating", "author_id")\n'
      'WHERE "books"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class AuthorInsertRequest {
  AuthorInsertRequest({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class BookInsertRequest {
  BookInsertRequest({
    required this.title,
    required this.isBestSelling,
    required this.rating,
    required this.authorId,
  });

  final String title;
  final bool isBestSelling;
  final int rating;
  final String authorId;
}

class AuthorUpdateRequest {
  AuthorUpdateRequest({
    required this.id,
    this.name,
  });

  final String id;
  final String? name;
}

class BookUpdateRequest {
  BookUpdateRequest({
    required this.id,
    this.title,
    this.isBestSelling,
    this.rating,
    this.authorId,
  });

  final int id;
  final String? title;
  final bool? isBestSelling;
  final int? rating;
  final String? authorId;
}

class AuthorViewQueryable extends KeyedViewQueryable<AuthorView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "authors".*'
      'FROM "authors"';

  @override
  String get tableAlias => 'authors';

  @override
  AuthorView decode(TypedMap map) => AuthorView(id: map.get('id'), name: map.get('name'));
}

class AuthorView {
  AuthorView({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class BookViewQueryable extends KeyedViewQueryable<BookView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

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
      isBestSelling: map.get('is_best_selling'),
      rating: map.get('rating'),
      author: map.get('author', AuthorViewQueryable().decoder));
}

class BookView {
  BookView({
    required this.id,
    required this.title,
    required this.isBestSelling,
    required this.rating,
    required this.author,
  });

  final int id;
  final String title;
  final bool isBestSelling;
  final int rating;
  final AuthorView author;
}
