import 'magic_annotation.dart';

/// Used to annotate a field as the primary key of the table.
///
/// {@category Models}
class PrimaryKey extends MagicAnnotation {
  const PrimaryKey({this.multi = false, this.order});

  final bool multi;
  final int? order;

  @override
  String toString() => '$runtimeType(multi: $multi, order: $multi)';
}
