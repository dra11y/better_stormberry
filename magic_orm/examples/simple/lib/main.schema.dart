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
        ModelRepositoryUpdate<InvoiceUpdateRequest> {
  factory InvoiceRepository._(PgDatabase db) = _InvoiceRepository;
}

class _InvoiceRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, InvoiceInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, InvoiceUpdateRequest>
    implements InvoiceRepository {
  _InvoiceRepository(super.db) : super(tableName: 'invoices');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<void> insert(List<InvoiceInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "invoices" (  )\n'
      'VALUES ${requests.map((r) => '(  )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<InvoiceUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "invoices"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '(  )').join(', ')} )\n'
      'AS UPDATED()\n'
      'WHERE ',
      values.values,
    );
  }
}

abstract class PartyRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<PartyInsertRequest>,
        ModelRepositoryUpdate<PartyUpdateRequest> {
  factory PartyRepository._(PgDatabase db) = _PartyRepository;
}

class _PartyRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, PartyInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, PartyUpdateRequest>
    implements PartyRepository {
  _PartyRepository(super.db) : super(tableName: 'parties');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<void> insert(List<PartyInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "parties" (  )\n'
      'VALUES ${requests.map((r) => '(  )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<PartyUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "parties"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '(  )').join(', ')} )\n'
      'AS UPDATED()\n'
      'WHERE ',
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
  Future<void> insert(List<BillingAddressInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "billing_addresses" (  )\n'
      'VALUES ${requests.map((r) => '(  )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<BillingAddressUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "billing_addresses"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '(  )').join(', ')} )\n'
      'AS UPDATED()\n'
      'WHERE ',
      values.values,
    );
  }
}

abstract class AccountRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<AccountInsertRequest>,
        ModelRepositoryUpdate<AccountUpdateRequest> {
  factory AccountRepository._(PgDatabase db) = _AccountRepository;
}

class _AccountRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, AccountInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, AccountUpdateRequest>
    implements AccountRepository {
  _AccountRepository(super.db) : super(tableName: 'accounts');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<void> insert(List<AccountInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "accounts" (  )\n'
      'VALUES ${requests.map((r) => '(  )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<AccountUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "accounts"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '(  )').join(', ')} )\n'
      'AS UPDATED()\n'
      'WHERE ',
      values.values,
    );
  }
}

abstract class CompanyRepository
    implements
        ModelRepository<PgDatabase>,
        ModelRepositoryInsert<CompanyInsertRequest>,
        ModelRepositoryUpdate<CompanyUpdateRequest> {
  factory CompanyRepository._(PgDatabase db) = _CompanyRepository;
}

class _CompanyRepository extends BaseRepository<PgDatabase>
    with
        RepositoryInsertMixin<PgDatabase, CompanyInsertRequest>,
        RepositoryUpdateMixin<PgDatabase, CompanyUpdateRequest>
    implements CompanyRepository {
  _CompanyRepository(super.db) : super(tableName: 'companies');

  @override
  Future<List<T>> queryMany<T>(ViewQueryable<T> q, [QueryParams? params]) {
    return query(PgViewQuery<T>(q), params ?? const QueryParams());
  }

  @override
  Future<void> insert(List<CompanyInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "companies" (  )\n'
      'VALUES ${requests.map((r) => '(  )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<CompanyUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "companies"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '(  )').join(', ')} )\n'
      'AS UPDATED()\n'
      'WHERE ',
      values.values,
    );
  }
}
