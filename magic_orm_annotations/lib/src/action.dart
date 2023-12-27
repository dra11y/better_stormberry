import 'database.dart';

/// Extend this to define a custom action.
///
/// {@category Queries & Actions}
abstract class Action<T> {
  const Action();
  Future<void> apply(Database db, T request);
}
