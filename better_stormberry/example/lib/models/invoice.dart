import 'package:better_stormberry/better_stormberry.dart';
import 'package:better_stormberry_annotations/better_stormberry_annotations.dart';

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
