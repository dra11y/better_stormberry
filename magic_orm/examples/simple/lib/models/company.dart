import 'package:dart_mappable/dart_mappable.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'address.dart';
import 'invoice.dart';
import 'party.dart';

part 'company.mapper.dart';

@Model()
@MappableClass()
class Company with CompanyMappable {
  @PrimaryKey(multi: true)
  final String? id;

  @PrimaryKey(multi: true)
  final String name;

  @HasOne(foreignKey: #companyPrimary)
  final BillingAddress? primaryAddress;

  @HasMany(foreignKey: #companySecondary)
  final List<BillingAddress> secondaryAddresses;

  @HasMany()
  final List<Account> members;

  @HasMany()
  final List<Invoice> invoices;

  @HasMany(foreignKey: #sponsor)
  final List<Party> parties;

  @BelongsTo(optional: true)
  final Company? parent;

  const Company({
    this.id,
    this.parent,
    required this.name,
    required this.primaryAddress,
    this.secondaryAddresses = const [],
    this.members = const [],
    this.invoices = const [],
    this.parties = const [],
  });
}
