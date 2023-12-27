// ignore_for_file: annotate_overrides

part of 'model.dart';

extension ModelRepositories on PgDatabase {
  ARepository get as => ARepository._(this);
  BRepository get bs => BRepository._(this);
}

abstract class ARepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<AInsertRequest>,
        ModelRepositoryUpdate<AUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory ARepository._(PgDatabase db) = _ARepository;

  Future<AView?> queryA(String id);
  Future<List<AView>> queryAs([QueryParams? params]);
}

class _ARepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, AInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, AUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements ARepository {
  _ARepository(super.db) : super(tableName: 'as', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<AView?> queryA(String id) {
    return queryOne(id, AViewQueryable());
  }

  @override
  Future<List<AView>> queryAs([QueryParams? params]) {
    return queryMany(AViewQueryable(), params);
  }

  @override
  Future<void> insert(List<AInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "as" ( "id", "a", "b", "c", "d", "e", "f" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.a)}:text, ${values.add(r.b)}:int8, ${values.add(r.c)}:float8, ${values.add(r.d)}:boolean, ${values.add(r.e)}:_int8, ${values.add(r.f)}:_float8 )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<AUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "as"\n'
      'SET "a" = COALESCE(UPDATED."a", "as"."a"), "b" = COALESCE(UPDATED."b", "as"."b"), "c" = COALESCE(UPDATED."c", "as"."c"), "d" = COALESCE(UPDATED."d", "as"."d"), "e" = COALESCE(UPDATED."e", "as"."e"), "f" = COALESCE(UPDATED."f", "as"."f")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.a)}:text::text, ${values.add(r.b)}:int8::int8, ${values.add(r.c)}:float8::float8, ${values.add(r.d)}:boolean::boolean, ${values.add(r.e)}:_int8::_int8, ${values.add(r.f)}:_float8::_float8 )').join(', ')} )\n'
      'AS UPDATED("id", "a", "b", "c", "d", "e", "f")\n'
      'WHERE "as"."id" = UPDATED."id"',
      values.values,
    );
  }
}

abstract class BRepository
    implements
        ModelRepository<PgDatabase>,
        KeyedModelRepositoryInsert<BInsertRequest>,
        ModelRepositoryUpdate<BUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory BRepository._(PgDatabase db) = _BRepository;

  Future<BView?> queryB(int id);
  Future<List<BView>> queryBs([QueryParams? params]);
}

class _BRepository extends BaseRepository<PgDatabase>
    with
        KeyedRepositoryInsertMixin<PgDatabase, BInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, BUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, int>
    implements BRepository {
  _BRepository(super.db) : super(tableName: 'bs', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<BView?> queryB(int id) {
    return queryOne(id, BViewQueryable());
  }

  @override
  Future<List<BView>> queryBs([QueryParams? params]) {
    return queryMany(BViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<BInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.query(
      'INSERT INTO "bs" ( "a_id", "b", "c", "d", "e" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.aId)}:text, ${values.add(r.b)}:text, ${values.add(r.c)}:int8, ${values.add(r.d)}:float8, ${values.add(r.e)}:boolean )').join(', ')}\n'
      'RETURNING "id"',
      values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<BUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "bs"\n'
      'SET "a_id" = COALESCE(UPDATED."a_id", "bs"."a_id"), "b" = COALESCE(UPDATED."b", "bs"."b"), "c" = COALESCE(UPDATED."c", "bs"."c"), "d" = COALESCE(UPDATED."d", "bs"."d"), "e" = COALESCE(UPDATED."e", "bs"."e")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.aId)}:text::text, ${values.add(r.b)}:text::text, ${values.add(r.c)}:int8::int8, ${values.add(r.d)}:float8::float8, ${values.add(r.e)}:boolean::boolean )').join(', ')} )\n'
      'AS UPDATED("id", "a_id", "b", "c", "d", "e")\n'
      'WHERE "bs"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class AInsertRequest {
  AInsertRequest({
    required this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.f,
  });

  final String id;
  final String a;
  final int b;
  final double c;
  final bool d;
  final List<int> e;
  final List<double> f;
}

class BInsertRequest {
  BInsertRequest({
    required this.aId,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
  });

  final String aId;
  final String b;
  final int c;
  final double d;
  final bool e;
}

class AUpdateRequest {
  AUpdateRequest({
    required this.id,
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
  });

  final String id;
  final String? a;
  final int? b;
  final double? c;
  final bool? d;
  final List<int>? e;
  final List<double>? f;
}

class BUpdateRequest {
  BUpdateRequest({
    required this.id,
    this.aId,
    this.b,
    this.c,
    this.d,
    this.e,
  });

  final int id;
  final String? aId;
  final String? b;
  final int? c;
  final double? d;
  final bool? e;
}

class AViewQueryable extends KeyedViewQueryable<AView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "as".*'
      'FROM "as"';

  @override
  String get tableAlias => 'as';

  @override
  AView decode(TypedMap map) => AView(
      id: map.get('id'),
      a: map.get('a'),
      b: map.get('b'),
      c: map.get('c'),
      d: map.get('d'),
      e: map.getListOpt('e') ?? const [],
      f: map.getListOpt('f') ?? const []);
}

class AView {
  AView({
    required this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.f,
  });

  final String id;
  final String a;
  final int b;
  final double c;
  final bool d;
  final List<int> e;
  final List<double> f;
}

class BViewQueryable extends KeyedViewQueryable<BView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "bs".*, row_to_json("a".*) as "a"'
      'FROM "bs"'
      'LEFT JOIN (${AViewQueryable().query}) "a"'
      'ON "bs"."a_id" = "a"."id"';

  @override
  String get tableAlias => 'bs';

  @override
  BView decode(TypedMap map) => BView(
      id: map.get('id'),
      a: map.get('a', AViewQueryable().decoder),
      b: map.get('b'),
      c: map.get('c'),
      d: map.get('d'),
      e: map.get('e'));
}

class BView {
  BView({
    required this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
  });

  final int id;
  final AView a;
  final String b;
  final int c;
  final double d;
  final bool e;
}
