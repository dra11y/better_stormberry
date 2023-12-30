import 'has_relation.dart';

class HasMany extends HasRelation {
  const HasMany({this.foreignKey});

  final Symbol? foreignKey;

  @override
  String toString() => '$runtimeType(foreignKey: $foreignKey)';
}
