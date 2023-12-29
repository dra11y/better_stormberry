import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'company.dart';

@Model()
class Invoice {
  @PrimaryKey()
  final String? id;
  final String title;
  final String invoiceId;

  @BelongsTo()
  final Account? account;

  @BelongsTo()
  final Company? company;

  const Invoice({
    this.id,
    required this.title,
    required this.invoiceId,
    this.account,
    this.company,
  });
}
