import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'address.dart';
import 'company.dart';
import 'invoice.dart';
import 'latlng.dart';
import 'party.dart';

part 'account.relation.dart';

@Model()
class Account {
  @PrimaryKey()
  @AutoIncrement()
  final int? id;

  // Fields
  final String firstName;
  final String lastName;

  // Custom Type
  @UseConverter(LatLngConverter())
  final LatLng location;

  @BelongsTo()
  final Company? company;

  // Foreign Object
  @HasOne()
  final BillingAddress? billingAddress;

  @HasMany()
  final List<Invoice> invoices;

  // @TransformedIn(#Company, by: FilterByField('sponsor_id', '=', 'company_id'))
  final List<Party> parties;

  final $AccountRelationInfo relationInfo;

  const Account({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.location,
    this.billingAddress,
    this.invoices = const [],
    this.company,
    this.parties = const [],
    this.relationInfo = const $AccountRelationInfo(),
  });
}
