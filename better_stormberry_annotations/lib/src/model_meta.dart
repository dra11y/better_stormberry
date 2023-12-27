import 'class_meta.dart';

/// Metadata for the generated classes in order to use serialization for these classes.
///
/// {@category Models}
class ModelMeta {
  /// Metadata for the insert request class.
  final ClassMeta? insert;

  /// Metadata for the update request class.
  final ClassMeta? update;

  /// Metadata for all view classes.
  final ClassMeta? view;

  /// Metadata for specific view classes.
  final Map<Symbol, ClassMeta>? views;

  const ModelMeta({this.insert, this.update, this.view, this.views});

  const ModelMeta.all(ClassMeta meta)
      : insert = meta,
        update = meta,
        view = meta,
        views = null;
}
