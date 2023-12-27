import 'package:better_stormberry/better_stormberry.dart';
import 'package:better_stormberry_annotations/better_stormberry_annotations.dart';

import 'account.dart';
import 'address.dart';
import 'invoice.dart';
import 'party.dart';

part 'company.schema.dart';

@Model(views: [#Full, #Member])
abstract class Company {
  @PrimaryKey()
  String get id;

  String get name;

  List<BillingAddress> get addresses;

  @HiddenIn(#Member)
  @ViewedIn(#Full, as: #Company)
  List<Account> get members;

  @HiddenIn(#Member)
  @ViewedIn(#Full, as: #Owner)
  List<Invoice> get invoices;

  @HiddenIn(#Member)
  @ViewedIn(#Full, as: #Company)
  List<Party> get parties;
}
