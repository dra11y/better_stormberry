import 'model.dart';

/// Hides the annotated field in the given view.
///
/// {@category Models}
/// {@category Views}
class HiddenIn {
  final Symbol name;

  const HiddenIn(this.name);
  const HiddenIn.defaultView() : name = Model.defaultView;
}
