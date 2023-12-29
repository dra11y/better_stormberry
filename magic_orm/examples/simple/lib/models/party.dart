import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'company.dart';

part 'party.relation.dart';

@Model()
class Party {
  @PrimaryKey()
  final String? id;

  final String name;

  @HasMany()
  final List<Account> guests;

  @BelongsTo()
  final Company? sponsor;

  final DateTime date;

  final $PartyRelationInfo relationInfo;

  const Party({
    this.id,
    required this.name,
    required this.guests,
    required this.sponsor,
    required this.date,
    this.relationInfo = const $PartyRelationInfo(),
  });
}
