import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'base_repository.dart';

abstract class ModelRepositoryUpdate<UpdateRequest> {
  Future<void> updateOne(UpdateRequest request);
  Future<void> updateMany(List<UpdateRequest> requests);
}

mixin RepositoryUpdateMixin<D extends BaseDatabase, UpdateRequest>
    on BaseRepository<D> implements ModelRepositoryUpdate<UpdateRequest> {
  @override
  Future<void> updateOne(UpdateRequest request) =>
      transaction(() => update([request]));
  @override
  Future<void> updateMany(List<UpdateRequest> requests) =>
      transaction(() => update(requests));

  Future<void> update(List<UpdateRequest> requests);
}
