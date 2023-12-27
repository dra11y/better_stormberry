/// Used to annotate a relational field and specify a binding target.
///
/// The binding target must be a field of the referenced model that
/// refers back to this model. That field must also use the `@BindTo`
/// annotation set to this field, in order to form a closed loop.
///
/// {@category Models}
class BindTo {
  const BindTo(this.name);

  final Symbol name;
}
