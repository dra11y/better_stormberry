import 'database.dart';

/// Extend this to define a custom query.
///
/// {@category Queries & Actions}
abstract class Query<D extends Database, T, U> {
  const Query();
  Future<T> apply(D db, U params);
}
