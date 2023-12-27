import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'company.dart';

@Model(views: [#Owner])
class Invoice {
  @PrimaryKey()
  final String id;
  final String title;
  final String invoiceId;

  @HiddenIn(#Owner)
  final Account? account;

  @HiddenIn(#Owner)
  final Company? company;

  const Invoice({
    required this.id,
    required this.title,
    required this.invoiceId,
    required this.account,
    required this.company,
  });
}
