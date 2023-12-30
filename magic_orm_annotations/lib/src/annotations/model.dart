import 'magic_annotation.dart';
import 'model_meta.dart';
import 'table_index.dart';

/// Used to annotate a class as a database model
///
/// {@category Models}
class Model extends MagicAnnotation {
  /// The list of views this model defined.
  // final List<Symbol> views;

  /// A list of indexes that should be created for this table.
  final List<TableIndex> indexes;

  /// A custom name for this table.
  final String? tableName;

  /// Metadata for the generated classes in order to use serialization for these classes.
  final ModelMeta? meta;

  const Model({
    // this.views = const [],
    this.indexes = const [],
    this.tableName,
    this.meta,
  });

  /// The default view of a model.
  // static const Symbol defaultView = #$default$;

  @override
  String toString() =>
      '$runtimeType(tableName: $tableName, indexes: $indexes, meta: $meta)';
}
