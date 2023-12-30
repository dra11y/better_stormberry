import 'magic_annotation.dart';

/// Used to annotate a field as an auto increment value.
/// Can only be applied to an integer field.
///
/// {@category Models}
class AutoIncrement extends MagicAnnotation {
  const AutoIncrement();

  @override
  String toString() => '$runtimeType()';
}
