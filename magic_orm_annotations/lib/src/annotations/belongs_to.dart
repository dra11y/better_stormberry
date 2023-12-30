import 'has_relation.dart';

class BelongsTo extends HasRelation {
  const BelongsTo({this.optional = false, this.primaryKey});

  final bool optional;
  final Symbol? primaryKey;

  @override
  String toString() =>
      '$runtimeType(optional: $optional, primaryKey: $primaryKey)';
}
