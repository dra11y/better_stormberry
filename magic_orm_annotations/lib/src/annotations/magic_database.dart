import 'magic_annotation.dart';

class MagicDatabase extends MagicAnnotation {
  const MagicDatabase({required this.models});

  final List<Type> models;

  @override
  String toString() => '$runtimeType(models: $models)';
}
