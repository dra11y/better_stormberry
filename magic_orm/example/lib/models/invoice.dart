import 'package:magic_orm/magic_orm.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'company.dart';

part 'invoice.schema.dart';

@Model(views: [#Owner])
abstract class Invoice {
  @PrimaryKey()
  String get id;
  String get title;
  String get invoiceId;

  @HiddenIn(#Owner)
  Account? get account;

  @HiddenIn(#Owner)
  Company? get company;
}
