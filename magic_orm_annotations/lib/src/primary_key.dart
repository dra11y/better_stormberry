/// Used to annotate a field as the primary key of the table.
///
/// {@category Models}
class PrimaryKey {
  const PrimaryKey({this.multi = false, this.order});

  final bool multi;
  final int? order;
}
