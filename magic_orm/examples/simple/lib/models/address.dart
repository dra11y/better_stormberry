import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'account.dart';
import 'company.dart';

abstract class Address {
  final String name;
  final String street;

  const Address({required this.name, required this.street});
}

@Model(meta: ModelMeta(view: ClassMeta(implement: 'BillingAddress')))
class BillingAddress extends Address {
  @PrimaryKey()
  final String? id;

  final String city;
  final String postcode;

  @BelongsTo()
  // company_primary_id -> Company.id
  final Company? companyPrimary;

  @BelongsTo()
  // company_secondary_id -> Company.id
  final Company? companySecondary;

  @BelongsTo()
  // account_id -> Account.id
  final Account? account;

  const BillingAddress({
    this.id,
    required super.name,
    required super.street,
    required this.city,
    required this.postcode,
    this.companyPrimary,
    this.companySecondary,
    this.account,
  });
}
