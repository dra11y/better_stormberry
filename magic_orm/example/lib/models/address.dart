import 'package:magic_orm/magic_orm.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

part 'address.schema.dart';

class Address {
  final String name;
  final String street;

  Address(this.name, this.street);
}

@Model(meta: ModelMeta(view: ClassMeta(implement: 'BillingAddress')))
abstract class BillingAddress implements Address {
  String get city;
  String get postcode;

  factory BillingAddress({
    required String name,
    required String street,
    required String city,
    required String postcode,
  }) = BillingAddressView;
}
