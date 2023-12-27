import 'dart:convert';

import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import '../core/query_params.dart';
import 'text_encoder.dart';

abstract class ViewQueryable<T> {
  String get tableAlias;
  String get query;

  T decode(TypedMap map);

  T decoder(dynamic v) {
    if (v is T) return v;
    if (v is Map) return decode(TypedMap(v.cast<String, dynamic>()));
    if (v is String) {
      try {
        decoder(jsonDecode(v));
      } catch (_) {}
    }
    throw 'Cannot decode value of type ${v.runtimeType} to $T';
  }
}

abstract class KeyedViewQueryable<T, K> extends ViewQueryable<T> {
  String get keyName;

  String encodeKey(K key);
}

abstract class ViewQuery<D extends BaseDatabase, Result>
    implements Query<D, List<Result>, QueryParams> {
  ViewQuery(this.queryable);

  final ViewQueryable<Result> queryable;

  @override
  Future<List<Result>> apply(D db, QueryParams params);
}
