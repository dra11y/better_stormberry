import 'model.dart';
import 'transformer.dart';

/// Applies the transformer on the annotated field in the given view.
///
/// {@category Models}
/// {@category Views}
class TransformedIn {
  final Symbol name;
  final Transformer by;

  const TransformedIn(this.name, {required this.by});
  const TransformedIn.defaultView({required this.by})
      : name = Model.defaultView;
}
