// ignore_for_file: annotate_overrides

part of 'author.dart';

extension AuthorRepositories on PgDatabase {
  AuthorRepository get authors => AuthorRepository._(this);
}

abstract class AuthorRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<AuthorInsertRequest>,
        ModelRepositoryUpdate<AuthorUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory AuthorRepository._(PgDatabase db) = _AuthorRepository;

  Future<AuthorView?> queryAuthor(String id);
  Future<List<AuthorView>> queryAuthors([QueryParams? params]);
}

class _AuthorRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, AuthorInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, AuthorUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements AuthorRepository {
  _AuthorRepository(super.db) : super(tableName: 'authors', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

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
      'INSERT INTO "authors" ( "id", "first_name", "last_name" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.firstName)}:text, ${values.add(r.lastName)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<AuthorUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "authors"\n'
      'SET "first_name" = COALESCE(UPDATED."first_name", "authors"."first_name"), "last_name" = COALESCE(UPDATED."last_name", "authors"."last_name")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.firstName)}:text::text, ${values.add(r.lastName)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "first_name", "last_name")\n'
      'WHERE "authors"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class AuthorInsertRequest {
  AuthorInsertRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final String id;
  final String firstName;
  final String lastName;
}

class AuthorUpdateRequest {
  AuthorUpdateRequest({
    required this.id,
    this.firstName,
    this.lastName,
  });

  final String id;
  final String? firstName;
  final String? lastName;
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
  AuthorView decode(TypedMap map) => AuthorView(
      id: map.get('id'), firstName: map.get('first_name'), lastName: map.get('last_name'));
}

class AuthorView {
  AuthorView({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final String id;
  final String firstName;
  final String lastName;
}
