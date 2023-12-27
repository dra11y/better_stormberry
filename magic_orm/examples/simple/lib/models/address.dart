import 'package:magic_orm_annotations/magic_orm_annotations.dart';

class Address {
  final String name;
  final String street;

  Address(this.name, this.street);
}

@Model(meta: ModelMeta(view: ClassMeta(implement: 'BillingAddress')))
class BillingAddress implements Address {
  final String city;
  final String postcode;

  const BillingAddress({
    required this.name,
    required this.street,
    required this.city,
    required this.postcode,
  });

  @override
  final String name;

  @override
  final String street;
}
