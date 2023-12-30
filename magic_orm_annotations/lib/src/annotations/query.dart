import 'base_database.dart';

/// Extend this to define a custom query.
///
/// {@category Queries & Actions}
abstract class Query<D extends BaseDatabase, T, U> {
  const Query();
  Future<T> apply(D db, U params);
}
