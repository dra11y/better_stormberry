import 'package:magic_orm_annotations/magic_orm_annotations.dart';

abstract class Address {
  final String name;
  final String street;

  const Address({required this.name, required this.street});
}

@Model(meta: ModelMeta(view: ClassMeta(implement: 'BillingAddress')))
class BillingAddress extends Address {
  final String city;
  final String postcode;

  const BillingAddress({
    required super.name,
    required super.street,
    required this.city,
    required this.postcode,
  });
}
