// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'company.dart';

class CompanyMapper extends ClassMapperBase<Company> {
  CompanyMapper._();

  static CompanyMapper? _instance;
  static CompanyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CompanyMapper._());
      CompanyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Company';

  static String? _$id(Company v) => v.id;
  static const Field<Company, String> _f$id = Field('id', _$id, opt: true);
  static Company? _$parent(Company v) => v.parent;
  static const Field<Company, Company> _f$parent =
      Field('parent', _$parent, opt: true);
  static String _$name(Company v) => v.name;
  static const Field<Company, String> _f$name = Field('name', _$name);
  static BillingAddress? _$primaryAddress(Company v) => v.primaryAddress;
  static const Field<Company, BillingAddress> _f$primaryAddress =
      Field('primaryAddress', _$primaryAddress);
  static List<BillingAddress> _$secondaryAddresses(Company v) =>
      v.secondaryAddresses;
  static const Field<Company, List<BillingAddress>> _f$secondaryAddresses =
      Field('secondaryAddresses', _$secondaryAddresses,
          opt: true, def: const []);
  static List<Account> _$members(Company v) => v.members;
  static const Field<Company, List<Account>> _f$members =
      Field('members', _$members, opt: true, def: const []);
  static List<Invoice> _$invoices(Company v) => v.invoices;
  static const Field<Company, List<Invoice>> _f$invoices =
      Field('invoices', _$invoices, opt: true, def: const []);
  static List<Party> _$parties(Company v) => v.parties;
  static const Field<Company, List<Party>> _f$parties =
      Field('parties', _$parties, opt: true, def: const []);

  @override
  final MappableFields<Company> fields = const {
    #id: _f$id,
    #parent: _f$parent,
    #name: _f$name,
    #primaryAddress: _f$primaryAddress,
    #secondaryAddresses: _f$secondaryAddresses,
    #members: _f$members,
    #invoices: _f$invoices,
    #parties: _f$parties,
  };

  static Company _instantiate(DecodingData data) {
    return Company(
        id: data.dec(_f$id),
        parent: data.dec(_f$parent),
        name: data.dec(_f$name),
        primaryAddress: data.dec(_f$primaryAddress),
        secondaryAddresses: data.dec(_f$secondaryAddresses),
        members: data.dec(_f$members),
        invoices: data.dec(_f$invoices),
        parties: data.dec(_f$parties));
  }

  @override
  final Function instantiate = _instantiate;

  static Company fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Company>(map);
  }

  static Company fromJson(String json) {
    return ensureInitialized().decodeJson<Company>(json);
  }
}

mixin CompanyMappable {
  String toJson() {
    return CompanyMapper.ensureInitialized()
        .encodeJson<Company>(this as Company);
  }

  Map<String, dynamic> toMap() {
    return CompanyMapper.ensureInitialized()
        .encodeMap<Company>(this as Company);
  }

  CompanyCopyWith<Company, Company, Company> get copyWith =>
      _CompanyCopyWithImpl(this as Company, $identity, $identity);
  @override
  String toString() {
    return CompanyMapper.ensureInitialized().stringifyValue(this as Company);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            CompanyMapper.ensureInitialized()
                .isValueEqual(this as Company, other));
  }

  @override
  int get hashCode {
    return CompanyMapper.ensureInitialized().hashValue(this as Company);
  }
}

extension CompanyValueCopy<$R, $Out> on ObjectCopyWith<$R, Company, $Out> {
  CompanyCopyWith<$R, Company, $Out> get $asCompany =>
      $base.as((v, t, t2) => _CompanyCopyWithImpl(v, t, t2));
}

abstract class CompanyCopyWith<$R, $In extends Company, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CompanyCopyWith<$R, Company, Company>? get parent;
  ListCopyWith<$R, BillingAddress,
          ObjectCopyWith<$R, BillingAddress, BillingAddress>>
      get secondaryAddresses;
  ListCopyWith<$R, Account, ObjectCopyWith<$R, Account, Account>> get members;
  ListCopyWith<$R, Invoice, ObjectCopyWith<$R, Invoice, Invoice>> get invoices;
  ListCopyWith<$R, Party, ObjectCopyWith<$R, Party, Party>> get parties;
  $R call(
      {String? id,
      Company? parent,
      String? name,
      BillingAddress? primaryAddress,
      List<BillingAddress>? secondaryAddresses,
      List<Account>? members,
      List<Invoice>? invoices,
      List<Party>? parties});
  CompanyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CompanyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Company, $Out>
    implements CompanyCopyWith<$R, Company, $Out> {
  _CompanyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Company> $mapper =
      CompanyMapper.ensureInitialized();
  @override
  CompanyCopyWith<$R, Company, Company>? get parent =>
      $value.parent?.copyWith.$chain((v) => call(parent: v));
  @override
  ListCopyWith<$R, BillingAddress,
          ObjectCopyWith<$R, BillingAddress, BillingAddress>>
      get secondaryAddresses => ListCopyWith(
          $value.secondaryAddresses,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(secondaryAddresses: v));
  @override
  ListCopyWith<$R, Account, ObjectCopyWith<$R, Account, Account>> get members =>
      ListCopyWith($value.members, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(members: v));
  @override
  ListCopyWith<$R, Invoice, ObjectCopyWith<$R, Invoice, Invoice>>
      get invoices => ListCopyWith($value.invoices,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(invoices: v));
  @override
  ListCopyWith<$R, Party, ObjectCopyWith<$R, Party, Party>> get parties =>
      ListCopyWith($value.parties, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(parties: v));
  @override
  $R call(
          {Object? id = $none,
          Object? parent = $none,
          String? name,
          Object? primaryAddress = $none,
          List<BillingAddress>? secondaryAddresses,
          List<Account>? members,
          List<Invoice>? invoices,
          List<Party>? parties}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (parent != $none) #parent: parent,
        if (name != null) #name: name,
        if (primaryAddress != $none) #primaryAddress: primaryAddress,
        if (secondaryAddresses != null) #secondaryAddresses: secondaryAddresses,
        if (members != null) #members: members,
        if (invoices != null) #invoices: invoices,
        if (parties != null) #parties: parties
      }));
  @override
  Company $make(CopyWithData data) => Company(
      id: data.get(#id, or: $value.id),
      parent: data.get(#parent, or: $value.parent),
      name: data.get(#name, or: $value.name),
      primaryAddress: data.get(#primaryAddress, or: $value.primaryAddress),
      secondaryAddresses:
          data.get(#secondaryAddresses, or: $value.secondaryAddresses),
      members: data.get(#members, or: $value.members),
      invoices: data.get(#invoices, or: $value.invoices),
      parties: data.get(#parties, or: $value.parties));

  @override
  CompanyCopyWith<$R2, Company, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CompanyCopyWithImpl($value, $cast, t);
}
