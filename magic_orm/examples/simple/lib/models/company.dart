import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'address.dart';
import 'invoice.dart';
import 'party.dart';

@Model()
class Company {
  @PrimaryKey()
  final String? id;

  final String name;

  @HasOne(field: #companyPrimary)
  final BillingAddress? primaryAddress;

  @HasMany(field: #companySecondary)
  final List<BillingAddress> secondaryAddresses;

  @HasMany()
  final List<Account> members;

  @HasMany()
  final List<Invoice> invoices;

  @HasMany(field: #sponsor)
  final List<Party> parties;

  @BelongsTo()
  final Company? parent;

  @BelongsTo()
  final Company? company;

  const Company({
    this.id,
    this.parent,
    this.company,
    required this.name,
    required this.primaryAddress,
    this.secondaryAddresses = const [],
    this.members = const [],
    this.invoices = const [],
    this.parties = const [],
  });
}
