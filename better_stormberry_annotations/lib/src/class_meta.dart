/// Metadata for a generated class.
///
/// {@category Models}
class ClassMeta {
  /// An annotation to be applied to the generated class.
  final Object? annotation;

  /// Additional mixins for the generated class.
  ///
  /// Supports the '{name}' template which will be replaced with the target class name.
  final String? mixin;

  /// Extends clause for the generated class.
  ///
  /// Supports the '{name}' template which will be replaced with the target class name.
  final String? extend;

  /// Additional interfaces for the generated class.
  ///
  /// Supports the '{name}' template which will be replaced with the target class name.
  final String? implement;

  const ClassMeta({this.annotation, this.mixin, this.extend, this.implement});
}
