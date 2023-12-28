// ignore_for_file: annotate_overrides

part of 'main.dart';

extension MainRepositories on PgDatabase {
  InvoiceRepository get invoices => InvoiceRepository._(this);
  PartyRepository get parties => PartyRepository._(this);
  BillingAddressRepository get billingAddresses => BillingAddressRepository._(this);
  AccountRepository get accounts => AccountRepository._(this);
  CompanyRepository get companies => CompanyRepository._(this);
}

abstract class InvoiceRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<InvoiceInsertRequest>,
        ModelRepositoryUpdate<InvoiceUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory InvoiceRepository._(PgDatabase db) = _InvoiceRepository;

  Future<OwnerInvoiceView?> queryOwnerView(String id);
  Future<List<OwnerInvoiceView>> queryOwnerViews([QueryParams? params]);
}

class _InvoiceRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, InvoiceInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, InvoiceUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements InvoiceRepository {
  _InvoiceRepository(super.db) : super(tableName: 'invoices', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<OwnerInvoiceView?> queryOwnerView(String id) {
    return queryOne(id, OwnerInvoiceViewQueryable());
  }

  @override
  Future<List<OwnerInvoiceView>> queryOwnerViews([QueryParams? params]) {
    return queryMany(OwnerInvoiceViewQueryable(), params);
  }

  @override
  Future<void> insert(List<InvoiceInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "invoices" ( "id", "title", "invoice_id", "account_id", "company_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.title)}:text, ${values.add(r.invoiceId)}:text, ${values.add(r.accountId)}:int8, ${values.add(r.companyId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<InvoiceUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "invoices"\n'
      'SET "title" = COALESCE(UPDATED."title", "invoices"."title"), "invoice_id" = COALESCE(UPDATED."invoice_id", "invoices"."invoice_id"), "account_id" = COALESCE(UPDATED."account_id", "invoices"."account_id"), "company_id" = COALESCE(UPDATED."company_id", "invoices"."company_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.title)}:text::text, ${values.add(r.invoiceId)}:text::text, ${values.add(r.accountId)}:int8::int8, ${values.add(r.companyId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "title", "invoice_id", "account_id", "company_id")\n'
      'WHERE "invoices"."id" = UPDATED."id"',
      values.values,
    );
  }
}

abstract class PartyRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<PartyInsertRequest>,
        ModelRepositoryUpdate<PartyUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory PartyRepository._(PgDatabase db) = _PartyRepository;

  Future<GuestPartyView?> queryGuestView(String id);
  Future<List<GuestPartyView>> queryGuestViews([QueryParams? params]);
  Future<CompanyPartyView?> queryCompanyView(String id);
  Future<List<CompanyPartyView>> queryCompanyViews([QueryParams? params]);
}

class _PartyRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, PartyInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, PartyUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements PartyRepository {
  _PartyRepository(super.db) : super(tableName: 'parties', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<GuestPartyView?> queryGuestView(String id) {
    return queryOne(id, GuestPartyViewQueryable());
  }

  @override
  Future<List<GuestPartyView>> queryGuestViews([QueryParams? params]) {
    return queryMany(GuestPartyViewQueryable(), params);
  }

  @override
  Future<CompanyPartyView?> queryCompanyView(String id) {
    return queryOne(id, CompanyPartyViewQueryable());
  }

  @override
  Future<List<CompanyPartyView>> queryCompanyViews([QueryParams? params]) {
    return queryMany(CompanyPartyViewQueryable(), params);
  }

  @override
  Future<void> insert(List<PartyInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "parties" ( "id", "name", "sponsor_id", "date" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.name)}:text, ${values.add(r.sponsorId)}:text, ${values.add(r.date)}:int8 )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<PartyUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "parties"\n'
      'SET "name" = COALESCE(UPDATED."name", "parties"."name"), "sponsor_id" = COALESCE(UPDATED."sponsor_id", "parties"."sponsor_id"), "date" = COALESCE(UPDATED."date", "parties"."date")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.sponsorId)}:text::text, ${values.add(r.date)}:int8::int8 )').join(', ')} )\n'
      'AS UPDATED("id", "name", "sponsor_id", "date")\n'
      'WHERE "parties"."id" = UPDATED."id"',
      values.values,
    );
  }
}

abstract class BillingAddressRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<BillingAddressInsertRequest>,
        ModelRepositoryUpdate<BillingAddressUpdateRequest> {
  factory BillingAddressRepository._(PgDatabase db) = _BillingAddressRepository;

  Future<List<BillingAddressView>> queryBillingAddresses([QueryParams? params]);
}

class _BillingAddressRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, BillingAddressInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, BillingAddressUpdateRequest>
    implements BillingAddressRepository {
  _BillingAddressRepository(super.db) : super(tableName: 'billing_addresses');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<List<BillingAddressView>> queryBillingAddresses([QueryParams? params]) {
    return queryMany(BillingAddressViewQueryable(), params);
  }

  @override
  Future<void> insert(List<BillingAddressInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "billing_addresses" ( "city", "postcode", "name", "street", "account_id", "company_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.city)}:text, ${values.add(r.postcode)}:text, ${values.add(r.name)}:text, ${values.add(r.street)}:text, ${values.add(r.accountId)}:int8, ${values.add(r.companyId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<BillingAddressUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "billing_addresses"\n'
      'SET "city" = COALESCE(UPDATED."city", "billing_addresses"."city"), "postcode" = COALESCE(UPDATED."postcode", "billing_addresses"."postcode"), "name" = COALESCE(UPDATED."name", "billing_addresses"."name"), "street" = COALESCE(UPDATED."street", "billing_addresses"."street")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.city)}:text::text, ${values.add(r.postcode)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.street)}:text::text, ${values.add(r.accountId)}:int8::int8, ${values.add(r.companyId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("city", "postcode", "name", "street", "account_id", "company_id")\n'
      'WHERE "billing_addresses"."account_id" = UPDATED."account_id" AND "billing_addresses"."company_id" = UPDATED."company_id"',
      values.values,
    );
  }
}

abstract class AccountRepository
    implements
        ModelRepository<PgDatabase>,
        KeyedModelRepositoryInsert<AccountInsertRequest>,
        ModelRepositoryUpdate<AccountUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory AccountRepository._(PgDatabase db) = _AccountRepository;

  Future<FullAccountView?> queryFullView(int id);
  Future<List<FullAccountView>> queryFullViews([QueryParams? params]);
  Future<UserAccountView?> queryUserView(int id);
  Future<List<UserAccountView>> queryUserViews([QueryParams? params]);
  Future<CompanyAccountView?> queryCompanyView(int id);
  Future<List<CompanyAccountView>> queryCompanyViews([QueryParams? params]);
}

class _AccountRepository extends BaseRepository<PgDatabase>
    with
        KeyedRepositoryInsertMixin<PgDatabase, AccountInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, AccountUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, int>
    implements AccountRepository {
  _AccountRepository(super.db) : super(tableName: 'accounts', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<FullAccountView?> queryFullView(int id) {
    return queryOne(id, FullAccountViewQueryable());
  }

  @override
  Future<List<FullAccountView>> queryFullViews([QueryParams? params]) {
    return queryMany(FullAccountViewQueryable(), params);
  }

  @override
  Future<UserAccountView?> queryUserView(int id) {
    return queryOne(id, UserAccountViewQueryable());
  }

  @override
  Future<List<UserAccountView>> queryUserViews([QueryParams? params]) {
    return queryMany(UserAccountViewQueryable(), params);
  }

  @override
  Future<CompanyAccountView?> queryCompanyView(int id) {
    return queryOne(id, CompanyAccountViewQueryable());
  }

  @override
  Future<List<CompanyAccountView>> queryCompanyViews([QueryParams? params]) {
    return queryMany(CompanyAccountViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<AccountInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.query(
      'INSERT INTO "accounts" ( "first_name", "last_name", "location", "company_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.firstName)}:text, ${values.add(r.lastName)}:text, ${values.add(LatLngConverter().tryEncode(r.location))}:point, ${values.add(r.companyId)}:text )').join(', ')}\n'
      'RETURNING "id"',
      values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    await db.billingAddresses.insertMany(requests.where((r) => r.billingAddress != null).map((r) {
      return BillingAddressInsertRequest(
          city: r.billingAddress!.city,
          postcode: r.billingAddress!.postcode,
          name: r.billingAddress!.name,
          street: r.billingAddress!.street,
          accountId: result[requests.indexOf(r)],
          companyId: null);
    }).toList());

    return result;
  }

  @override
  Future<void> update(List<AccountUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "accounts"\n'
      'SET "first_name" = COALESCE(UPDATED."first_name", "accounts"."first_name"), "last_name" = COALESCE(UPDATED."last_name", "accounts"."last_name"), "location" = COALESCE(UPDATED."location", "accounts"."location"), "company_id" = COALESCE(UPDATED."company_id", "accounts"."company_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.firstName)}:text::text, ${values.add(r.lastName)}:text::text, ${values.add(LatLngConverter().tryEncode(r.location))}:point::point, ${values.add(r.companyId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "first_name", "last_name", "location", "company_id")\n'
      'WHERE "accounts"."id" = UPDATED."id"',
      values.values,
    );
    await db.billingAddresses.updateMany(requests.where((r) => r.billingAddress != null).map((r) {
      return BillingAddressUpdateRequest(
          city: r.billingAddress!.city,
          postcode: r.billingAddress!.postcode,
          name: r.billingAddress!.name,
          street: r.billingAddress!.street,
          accountId: r.id);
    }).toList());
  }
}

abstract class CompanyRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<CompanyInsertRequest>,
        ModelRepositoryUpdate<CompanyUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory CompanyRepository._(PgDatabase db) = _CompanyRepository;

  Future<FullCompanyView?> queryFullView(String id);
  Future<List<FullCompanyView>> queryFullViews([QueryParams? params]);
  Future<MemberCompanyView?> queryMemberView(String id);
  Future<List<MemberCompanyView>> queryMemberViews([QueryParams? params]);
}

class _CompanyRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, CompanyInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, CompanyUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements CompanyRepository {
  _CompanyRepository(super.db) : super(tableName: 'companies', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<FullCompanyView?> queryFullView(String id) {
    return queryOne(id, FullCompanyViewQueryable());
  }

  @override
  Future<List<FullCompanyView>> queryFullViews([QueryParams? params]) {
    return queryMany(FullCompanyViewQueryable(), params);
  }

  @override
  Future<MemberCompanyView?> queryMemberView(String id) {
    return queryOne(id, MemberCompanyViewQueryable());
  }

  @override
  Future<List<MemberCompanyView>> queryMemberViews([QueryParams? params]) {
    return queryMany(MemberCompanyViewQueryable(), params);
  }

  @override
  Future<void> insert(List<CompanyInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "companies" ( "id", "name" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.name)}:text )').join(', ')}\n',
      values.values,
    );

    await db.billingAddresses.insertMany(requests.expand((r) {
      return r.addresses.map((rr) => BillingAddressInsertRequest(
          city: rr.city,
          postcode: rr.postcode,
          name: rr.name,
          street: rr.street,
          accountId: null,
          companyId: r.id));
    }).toList());
  }

  @override
  Future<void> update(List<CompanyUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "companies"\n'
      'SET "name" = COALESCE(UPDATED."name", "companies"."name")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.name)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "name")\n'
      'WHERE "companies"."id" = UPDATED."id"',
      values.values,
    );
    await db.billingAddresses.updateMany(requests.where((r) => r.addresses != null).expand((r) {
      return r.addresses!.map((rr) => BillingAddressUpdateRequest(
          city: rr.city, postcode: rr.postcode, name: rr.name, street: rr.street, companyId: r.id));
    }).toList());
  }
}

class InvoiceInsertRequest {
  InvoiceInsertRequest({
    required this.id,
    required this.title,
    required this.invoiceId,
    this.accountId,
    this.companyId,
  });

  final String id;
  final String title;
  final String invoiceId;
  final int? accountId;
  final String? companyId;
}

class PartyInsertRequest {
  PartyInsertRequest({
    required this.id,
    required this.name,
    this.sponsorId,
    required this.date,
  });

  final String id;
  final String name;
  final String? sponsorId;
  final int date;
}

class BillingAddressInsertRequest {
  BillingAddressInsertRequest({
    required this.city,
    required this.postcode,
    required this.name,
    required this.street,
    this.accountId,
    this.companyId,
  });

  final String city;
  final String postcode;
  final String name;
  final String street;
  final int? accountId;
  final String? companyId;
}

class AccountInsertRequest {
  AccountInsertRequest({
    required this.firstName,
    required this.lastName,
    required this.location,
    this.billingAddress,
    this.companyId,
  });

  final String firstName;
  final String lastName;
  final LatLng location;
  final BillingAddress? billingAddress;
  final String? companyId;
}

class CompanyInsertRequest {
  CompanyInsertRequest({
    required this.id,
    required this.name,
    required this.addresses,
  });

  final String id;
  final String name;
  final List<BillingAddress> addresses;
}

class InvoiceUpdateRequest {
  InvoiceUpdateRequest({
    required this.id,
    this.title,
    this.invoiceId,
    this.accountId,
    this.companyId,
  });

  final String id;
  final String? title;
  final String? invoiceId;
  final int? accountId;
  final String? companyId;
}

class PartyUpdateRequest {
  PartyUpdateRequest({
    required this.id,
    this.name,
    this.sponsorId,
    this.date,
  });

  final String id;
  final String? name;
  final String? sponsorId;
  final int? date;
}

class BillingAddressUpdateRequest {
  BillingAddressUpdateRequest({
    this.city,
    this.postcode,
    this.name,
    this.street,
    this.accountId,
    this.companyId,
  });

  final String? city;
  final String? postcode;
  final String? name;
  final String? street;
  final int? accountId;
  final String? companyId;
}

class AccountUpdateRequest {
  AccountUpdateRequest({
    required this.id,
    this.firstName,
    this.lastName,
    this.location,
    this.billingAddress,
    this.companyId,
  });

  final int id;
  final String? firstName;
  final String? lastName;
  final LatLng? location;
  final BillingAddress? billingAddress;
  final String? companyId;
}

class CompanyUpdateRequest {
  CompanyUpdateRequest({
    required this.id,
    this.name,
    this.addresses,
  });

  final String id;
  final String? name;
  final List<BillingAddress>? addresses;
}

class OwnerInvoiceViewQueryable extends KeyedViewQueryable<OwnerInvoiceView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "invoices".*'
      'FROM "invoices"';

  @override
  String get tableAlias => 'invoices';

  @override
  OwnerInvoiceView decode(TypedMap map) => OwnerInvoiceView(
      id: map.get('id'), title: map.get('title'), invoiceId: map.get('invoice_id'));
}

class OwnerInvoiceView {
  OwnerInvoiceView({
    required this.id,
    required this.title,
    required this.invoiceId,
  });

  final String id;
  final String title;
  final String invoiceId;
}

class GuestPartyViewQueryable extends KeyedViewQueryable<GuestPartyView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "parties".*, row_to_json("sponsor".*) as "sponsor"'
      'FROM "parties"'
      'LEFT JOIN (${MemberCompanyViewQueryable().query}) "sponsor"'
      'ON "parties"."sponsor_id" = "sponsor"."id"';

  @override
  String get tableAlias => 'parties';

  @override
  GuestPartyView decode(TypedMap map) => GuestPartyView(
      id: map.get('id'),
      name: map.get('name'),
      sponsor: map.getOpt('sponsor', MemberCompanyViewQueryable().decoder),
      date: map.get('date'));
}

class GuestPartyView {
  GuestPartyView({
    required this.id,
    required this.name,
    this.sponsor,
    required this.date,
  });

  final String id;
  final String name;
  final MemberCompanyView? sponsor;
  final int date;
}

class CompanyPartyViewQueryable extends KeyedViewQueryable<CompanyPartyView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "parties".*'
      'FROM "parties"';

  @override
  String get tableAlias => 'parties';

  @override
  CompanyPartyView decode(TypedMap map) =>
      CompanyPartyView(id: map.get('id'), name: map.get('name'), date: map.get('date'));
}

class CompanyPartyView {
  CompanyPartyView({
    required this.id,
    required this.name,
    required this.date,
  });

  final String id;
  final String name;
  final int date;
}

class BillingAddressViewQueryable extends ViewQueryable<BillingAddressView> {
  @override
  String get query => 'SELECT "billing_addresses".*'
      'FROM "billing_addresses"';

  @override
  String get tableAlias => 'billing_addresses';

  @override
  BillingAddressView decode(TypedMap map) => BillingAddressView(
      city: map.get('city'),
      postcode: map.get('postcode'),
      name: map.get('name'),
      street: map.get('street'));
}

class BillingAddressView implements BillingAddress {
  BillingAddressView({
    required this.city,
    required this.postcode,
    required this.name,
    required this.street,
  });

  final String city;
  final String postcode;
  final String name;
  final String street;
}

class FullAccountViewQueryable extends KeyedViewQueryable<FullAccountView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query =>
      'SELECT "accounts".*, row_to_json("billingAddress".*) as "billingAddress", "invoices"."data" as "invoices", row_to_json("company".*) as "company", "parties"."data" as "parties"'
      'FROM "accounts"'
      'LEFT JOIN (${BillingAddressViewQueryable().query}) "billingAddress"'
      'ON "accounts"."id" = "billingAddress"."account_id"'
      'LEFT JOIN ('
      '  SELECT "invoices"."account_id",'
      '    to_jsonb(array_agg("invoices".*)) as data'
      '  FROM (${OwnerInvoiceViewQueryable().query}) "invoices"'
      '  GROUP BY "invoices"."account_id"'
      ') "invoices"'
      'ON "accounts"."id" = "invoices"."account_id"'
      'LEFT JOIN (${MemberCompanyViewQueryable().query}) "company"'
      'ON "accounts"."company_id" = "company"."id"'
      'LEFT JOIN ('
      '  SELECT "accounts_parties"."account_id",'
      '    to_jsonb(array_agg("parties".*)) as data'
      '  FROM "accounts_parties"'
      '  LEFT JOIN (${GuestPartyViewQueryable().query}) "parties"'
      '  ON "parties"."id" = "accounts_parties"."party_id"'
      '  GROUP BY "accounts_parties"."account_id"'
      ') "parties"'
      'ON "accounts"."id" = "parties"."account_id"';

  @override
  String get tableAlias => 'accounts';

  @override
  FullAccountView decode(TypedMap map) => FullAccountView(
      id: map.get('id'),
      firstName: map.get('first_name'),
      lastName: map.get('last_name'),
      location: map.get('location', LatLngConverter().decode),
      billingAddress: map.getOpt('billingAddress', BillingAddressViewQueryable().decoder),
      invoices: map.getListOpt('invoices', OwnerInvoiceViewQueryable().decoder) ?? const [],
      company: map.getOpt('company', MemberCompanyViewQueryable().decoder),
      parties: map.getListOpt('parties', GuestPartyViewQueryable().decoder) ?? const []);
}

class FullAccountView {
  FullAccountView({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.location,
    this.billingAddress,
    required this.invoices,
    this.company,
    required this.parties,
  });

  final int id;
  final String firstName;
  final String lastName;
  final LatLng location;
  final BillingAddressView? billingAddress;
  final List<OwnerInvoiceView> invoices;
  final MemberCompanyView? company;
  final List<GuestPartyView> parties;
}

class UserAccountViewQueryable extends KeyedViewQueryable<UserAccountView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query =>
      'SELECT "accounts".*, row_to_json("billingAddress".*) as "billingAddress", "invoices"."data" as "invoices", row_to_json("company".*) as "company", "parties"."data" as "parties"'
      'FROM "accounts"'
      'LEFT JOIN (${BillingAddressViewQueryable().query}) "billingAddress"'
      'ON "accounts"."id" = "billingAddress"."account_id"'
      'LEFT JOIN ('
      '  SELECT "invoices"."account_id",'
      '    to_jsonb(array_agg("invoices".*)) as data'
      '  FROM (${OwnerInvoiceViewQueryable().query}) "invoices"'
      '  GROUP BY "invoices"."account_id"'
      ') "invoices"'
      'ON "accounts"."id" = "invoices"."account_id"'
      'LEFT JOIN (${MemberCompanyViewQueryable().query}) "company"'
      'ON "accounts"."company_id" = "company"."id"'
      'LEFT JOIN ('
      '  SELECT "accounts_parties"."account_id",'
      '    to_jsonb(array_agg("parties".*)) as data'
      '  FROM "accounts_parties"'
      '  LEFT JOIN (${GuestPartyViewQueryable().query}) "parties"'
      '  ON "parties"."id" = "accounts_parties"."party_id"'
      '  GROUP BY "accounts_parties"."account_id"'
      ') "parties"'
      'ON "accounts"."id" = "parties"."account_id"';

  @override
  String get tableAlias => 'accounts';

  @override
  UserAccountView decode(TypedMap map) => UserAccountView(
      id: map.get('id'),
      firstName: map.get('first_name'),
      lastName: map.get('last_name'),
      location: map.get('location', LatLngConverter().decode),
      billingAddress: map.getOpt('billingAddress', BillingAddressViewQueryable().decoder),
      invoices: map.getListOpt('invoices', OwnerInvoiceViewQueryable().decoder) ?? const [],
      company: map.getOpt('company', MemberCompanyViewQueryable().decoder),
      parties: map.getListOpt('parties', GuestPartyViewQueryable().decoder) ?? const []);
}

class UserAccountView {
  UserAccountView({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.location,
    this.billingAddress,
    required this.invoices,
    this.company,
    required this.parties,
  });

  final int id;
  final String firstName;
  final String lastName;
  final LatLng location;
  final BillingAddressView? billingAddress;
  final List<OwnerInvoiceView> invoices;
  final MemberCompanyView? company;
  final List<GuestPartyView> parties;
}

class CompanyAccountViewQueryable extends KeyedViewQueryable<CompanyAccountView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query =>
      'SELECT "accounts".*, ${FilterByField('sponsor_id', '=', 'company_id').transform('parties', 'accounts')}'
      'FROM "accounts"'
      'LEFT JOIN ('
      '  SELECT "accounts_parties"."account_id",'
      '    to_jsonb(array_agg("parties".*)) as data'
      '  FROM "accounts_parties"'
      '  LEFT JOIN (${CompanyPartyViewQueryable().query}) "parties"'
      '  ON "parties"."id" = "accounts_parties"."party_id"'
      '  GROUP BY "accounts_parties"."account_id"'
      ') "parties"'
      'ON "accounts"."id" = "parties"."account_id"';

  @override
  String get tableAlias => 'accounts';

  @override
  CompanyAccountView decode(TypedMap map) => CompanyAccountView(
      id: map.get('id'),
      firstName: map.get('first_name'),
      lastName: map.get('last_name'),
      location: map.get('location', LatLngConverter().decode),
      parties: map.getListOpt('parties', CompanyPartyViewQueryable().decoder) ?? const []);
}

class CompanyAccountView {
  CompanyAccountView({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.parties,
  });

  final int id;
  final String firstName;
  final String lastName;
  final LatLng location;
  final List<CompanyPartyView> parties;
}

class FullCompanyViewQueryable extends KeyedViewQueryable<FullCompanyView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query =>
      'SELECT "companies".*, "addresses"."data" as "addresses", "members"."data" as "members", "invoices"."data" as "invoices", "parties"."data" as "parties"'
      'FROM "companies"'
      'LEFT JOIN ('
      '  SELECT "billing_addresses"."company_id",'
      '    to_jsonb(array_agg("billing_addresses".*)) as data'
      '  FROM (${BillingAddressViewQueryable().query}) "billing_addresses"'
      '  GROUP BY "billing_addresses"."company_id"'
      ') "addresses"'
      'ON "companies"."id" = "addresses"."company_id"'
      'LEFT JOIN ('
      '  SELECT "accounts"."company_id",'
      '    to_jsonb(array_agg("accounts".*)) as data'
      '  FROM (${CompanyAccountViewQueryable().query}) "accounts"'
      '  GROUP BY "accounts"."company_id"'
      ') "members"'
      'ON "companies"."id" = "members"."company_id"'
      'LEFT JOIN ('
      '  SELECT "invoices"."company_id",'
      '    to_jsonb(array_agg("invoices".*)) as data'
      '  FROM (${OwnerInvoiceViewQueryable().query}) "invoices"'
      '  GROUP BY "invoices"."company_id"'
      ') "invoices"'
      'ON "companies"."id" = "invoices"."company_id"'
      'LEFT JOIN ('
      '  SELECT "parties"."sponsor_id",'
      '    to_jsonb(array_agg("parties".*)) as data'
      '  FROM (${CompanyPartyViewQueryable().query}) "parties"'
      '  GROUP BY "parties"."sponsor_id"'
      ') "parties"'
      'ON "companies"."id" = "parties"."sponsor_id"';

  @override
  String get tableAlias => 'companies';

  @override
  FullCompanyView decode(TypedMap map) => FullCompanyView(
      id: map.get('id'),
      name: map.get('name'),
      addresses: map.getListOpt('addresses', BillingAddressViewQueryable().decoder) ?? const [],
      members: map.getListOpt('members', CompanyAccountViewQueryable().decoder) ?? const [],
      invoices: map.getListOpt('invoices', OwnerInvoiceViewQueryable().decoder) ?? const [],
      parties: map.getListOpt('parties', CompanyPartyViewQueryable().decoder) ?? const []);
}

class FullCompanyView {
  FullCompanyView({
    required this.id,
    required this.name,
    required this.addresses,
    required this.members,
    required this.invoices,
    required this.parties,
  });

  final String id;
  final String name;
  final List<BillingAddressView> addresses;
  final List<CompanyAccountView> members;
  final List<OwnerInvoiceView> invoices;
  final List<CompanyPartyView> parties;
}

class MemberCompanyViewQueryable extends KeyedViewQueryable<MemberCompanyView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "companies".*, "addresses"."data" as "addresses"'
      'FROM "companies"'
      'LEFT JOIN ('
      '  SELECT "billing_addresses"."company_id",'
      '    to_jsonb(array_agg("billing_addresses".*)) as data'
      '  FROM (${BillingAddressViewQueryable().query}) "billing_addresses"'
      '  GROUP BY "billing_addresses"."company_id"'
      ') "addresses"'
      'ON "companies"."id" = "addresses"."company_id"';

  @override
  String get tableAlias => 'companies';

  @override
  MemberCompanyView decode(TypedMap map) => MemberCompanyView(
      id: map.get('id'),
      name: map.get('name'),
      addresses: map.getListOpt('addresses', BillingAddressViewQueryable().decoder) ?? const []);
}

class MemberCompanyView {
  MemberCompanyView({
    required this.id,
    required this.name,
    required this.addresses,
  });

  final String id;
  final String name;
  final List<BillingAddressView> addresses;
}
