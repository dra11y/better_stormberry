import '../core/database.dart';
import 'base_repository.dart';

abstract class ModelRepositoryUpdate<UpdateRequest> {
  Future<void> updateOne(UpdateRequest request);
  Future<void> updateMany(List<UpdateRequest> requests);
}

mixin RepositoryUpdateMixin<UpdateRequest> on BaseRepository
    implements ModelRepositoryUpdate<UpdateRequest> {
  @override
  Future<void> updateOne(UpdateRequest request) => transaction(() => update([request]));
  @override
  Future<void> updateMany(List<UpdateRequest> requests) => transaction(() => update(requests));

  Future<void> update(List<UpdateRequest> requests);
}

class UpdateColumns<T, UpdateRequest> {
  final String columnName;
  final String columnType;
  final T Function(UpdateRequest) getValue;

  UpdateColumns(this.columnName, this.columnType, this.getValue);
}