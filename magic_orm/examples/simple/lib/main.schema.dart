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
  Future<void> insert(List<PartyInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "parties" ( "id", "name", "sponsor_id", "date" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.name)}:text, ${values.add(r.sponsorId)}:text, ${values.add(r.date)}:timestamp )').join(', ')}\n',
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
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.sponsorId)}:text::text, ${values.add(r.date)}:timestamp::timestamp )').join(', ')} )\n'
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
        ModelRepositoryUpdate<BillingAddressUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory BillingAddressRepository._(PgDatabase db) = _BillingAddressRepository;
}

class _BillingAddressRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, BillingAddressInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, BillingAddressUpdateRequest>,
        RepositoryDeleteMixin<PgDatabase, String>
    implements BillingAddressRepository {
  _BillingAddressRepository(super.db) : super(tableName: 'billing_addresses', keyName: 'id');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<void> insert(List<BillingAddressInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "billing_addresses" ( "id", "city", "postcode", "company_primary_id", "company_primary_id", "company_secondary_id", "account_id", "name", "street" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.city)}:text, ${values.add(r.postcode)}:text, ${values.add(r.companyPrimaryId)}:text, ${values.add(r.companyPrimaryId)}:text, ${values.add(r.companySecondaryId)}:text, ${values.add(r.accountId)}:int8, ${values.add(r.name)}:text, ${values.add(r.street)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<BillingAddressUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "billing_addresses"\n'
      'SET "city" = COALESCE(UPDATED."city", "billing_addresses"."city"), "postcode" = COALESCE(UPDATED."postcode", "billing_addresses"."postcode"), "company_primary_id" = COALESCE(UPDATED."company_primary_id", "billing_addresses"."company_primary_id"), "company_primary_id" = COALESCE(UPDATED."company_primary_id", "billing_addresses"."company_primary_id"), "company_secondary_id" = COALESCE(UPDATED."company_secondary_id", "billing_addresses"."company_secondary_id"), "account_id" = COALESCE(UPDATED."account_id", "billing_addresses"."account_id"), "name" = COALESCE(UPDATED."name", "billing_addresses"."name"), "street" = COALESCE(UPDATED."street", "billing_addresses"."street")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.city)}:text::text, ${values.add(r.postcode)}:text::text, ${values.add(r.companyPrimaryId)}:text::text, ${values.add(r.companyPrimaryId)}:text::text, ${values.add(r.companySecondaryId)}:text::text, ${values.add(r.accountId)}:int8::int8, ${values.add(r.name)}:text::text, ${values.add(r.street)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "city", "postcode", "company_primary_id", "company_primary_id", "company_secondary_id", "account_id", "name", "street")\n'
      'WHERE "billing_addresses"."id" = UPDATED."id"',
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
  Future<List<int>> insert(List<AccountInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.query(
      'INSERT INTO "accounts" ( "first_name", "last_name", "location", "company_id", "billing_address_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.firstName)}:text, ${values.add(r.lastName)}:text, ${values.add(LatLngConverter().tryEncode(r.location))}:point, ${values.add(r.companyId)}:text, ${values.add(r.billingAddressId)}:text )').join(', ')}\n'
      'RETURNING "id"',
      values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<AccountUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "accounts"\n'
      'SET "first_name" = COALESCE(UPDATED."first_name", "accounts"."first_name"), "last_name" = COALESCE(UPDATED."last_name", "accounts"."last_name"), "location" = COALESCE(UPDATED."location", "accounts"."location"), "company_id" = COALESCE(UPDATED."company_id", "accounts"."company_id"), "billing_address_id" = COALESCE(UPDATED."billing_address_id", "accounts"."billing_address_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.firstName)}:text::text, ${values.add(r.lastName)}:text::text, ${values.add(LatLngConverter().tryEncode(r.location))}:point::point, ${values.add(r.companyId)}:text::text, ${values.add(r.billingAddressId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "first_name", "last_name", "location", "company_id", "billing_address_id")\n'
      'WHERE "accounts"."id" = UPDATED."id"',
      values.values,
    );
  }
}

abstract class CompanyRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<CompanyInsertRequest>,
        ModelRepositoryUpdate<CompanyUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory CompanyRepository._(PgDatabase db) = _CompanyRepository;
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
  Future<void> insert(List<CompanyInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "companies" ( "id", "name", "primary_address_id", "primary_address_id", "parent_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.name)}:text, ${values.add(r.primaryAddressId)}:text, ${values.add(r.primaryAddressId)}:text, ${values.add(r.parentId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<CompanyUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "companies"\n'
      'SET "name" = COALESCE(UPDATED."name", "companies"."name"), "primary_address_id" = COALESCE(UPDATED."primary_address_id", "companies"."primary_address_id"), "primary_address_id" = COALESCE(UPDATED."primary_address_id", "companies"."primary_address_id"), "parent_id" = COALESCE(UPDATED."parent_id", "companies"."parent_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.primaryAddressId)}:text::text, ${values.add(r.primaryAddressId)}:text::text, ${values.add(r.parentId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("id", "name", "primary_address_id", "primary_address_id", "parent_id")\n'
      'WHERE "companies"."id" = UPDATED."id"',
      values.values,
    );
  }
}
