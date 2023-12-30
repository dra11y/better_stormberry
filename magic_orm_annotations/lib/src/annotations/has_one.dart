import 'has_relation.dart';

class HasOne extends HasRelation {
  const HasOne({this.foreignKey});

  final Symbol? foreignKey;

  @override
  String toString() => '$runtimeType(foreignKey: $foreignKey)';
}
