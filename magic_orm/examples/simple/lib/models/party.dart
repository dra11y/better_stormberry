import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'company.dart';

@Model(views: [#Guest, #Company])
class Party {
  @PrimaryKey()
  final String id;

  final String name;

  @HiddenIn(#Guest)
  @HiddenIn(#Company)
  final List<Account> guests;

  @ViewedIn(#Guest, as: #Member)
  @HiddenIn(#Company)
  final Company? sponsor;

  final int date;

  const Party({
    required this.id,
    required this.name,
    required this.guests,
    required this.sponsor,
    required this.date,
  });
}
