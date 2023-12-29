class BelongsTo {
  const BelongsTo({this.optional = false, this.primaryKeyField});

  final bool optional;
  final Symbol? primaryKeyField;
}
