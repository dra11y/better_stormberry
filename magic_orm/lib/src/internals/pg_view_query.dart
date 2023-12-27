import '../core/pg_database.dart';
import '../core/query_params.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';
import 'text_encoder.dart';
import 'view_query.dart';

class PgViewQuery<Result> extends ViewQuery<PgDatabase, Result> implements Query<PgDatabase, List<Result>, QueryParams> {
  PgViewQuery(super.queryable);

  @override
  Future<List<Result>> apply(PgDatabase db, QueryParams params) async {
    var time = DateTime.now();
    var res = await db.query("""
      SELECT * FROM (${queryable.query}) "${queryable.tableAlias}"
      ${params.where != null ? "WHERE ${params.where}" : ""}
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """, params.values);

    var results = res.map((row) => queryable.decode(TypedMap(row.toColumnMap()))).toList();
    print('Queried ${results.length} rows in ${DateTime.now().difference(time)}');
    return results;
  }
}
