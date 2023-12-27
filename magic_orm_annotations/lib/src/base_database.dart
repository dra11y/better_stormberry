import 'dart:async';

abstract class BaseDatabase<R extends List<List>> {
  Future open();
  Future close();
  Future<R> query(String query, [Map<String, dynamic>? values]);
  Future startTransaction();
  void cancelTransaction();
  Future<bool> finishTransaction();
  Future<T> runTransaction<T>(FutureOr<T> Function() run);
}
