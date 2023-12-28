import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'address.dart';
import 'invoice.dart';
import 'party.dart';

@Model(views: [#Full, #Member])
class Company {
  @PrimaryKey()
  final String id;

  final String name;

  final List<BillingAddress> addresses;

  @HiddenIn(#Member)
  @ViewedIn(#Full, as: #Company)
  final List<Account> members;

  @HiddenIn(#Member)
  @ViewedIn(#Full, as: #Owner)
  final List<Invoice> invoices;

  @HiddenIn(#Member)
  @ViewedIn(#Full, as: #Company)
  final List<Party> parties;

  const Company({
    required this.id,
    required this.name,
    required this.addresses,
    required this.members,
    required this.invoices,
    required this.parties,
  });
}
