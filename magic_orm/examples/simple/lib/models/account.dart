import 'package:magic_orm/magic_orm.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'address.dart';
import 'company.dart';
import 'invoice.dart';
import 'latlng.dart';
import 'party.dart';

@Model(views: [#Full, #User, #Company])
class Account {
  @PrimaryKey()
  @AutoIncrement()
  final int id;

  // Fields
  final String firstName;
  final String lastName;

  // Custom Type
  @UseConverter(LatLngConverter())
  final LatLng location;

  // Foreign Object
  @HiddenIn(#Company)
  final BillingAddress? billingAddress;

  @HiddenIn(#Company)
  @ViewedIn(#Full, as: #Owner)
  @ViewedIn(#User, as: #Owner)
  final List<Invoice> invoices;

  @HiddenIn(#Company)
  @ViewedIn(#Full, as: #Member)
  @ViewedIn(#User, as: #Member)
  final Company? company;

  @ViewedIn(#Company, as: #Company)
  @TransformedIn(#Company, by: FilterByField('sponsor_id', '=', 'company_id'))
  @ViewedIn(#Full, as: #Guest)
  @ViewedIn(#User, as: #Guest)
  final List<Party> parties;

  const Account({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.billingAddress,
    required this.invoices,
    required this.company,
    required this.parties,
  });
}
