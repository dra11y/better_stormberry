import 'package:magic_orm/magic_orm.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'models.export.dart';
import 'models/address.dart';
import 'models/company.dart';
import 'models/latlng.dart';

part 'main.schema.dart';

@MagicDatabase(models: models)
class Database extends PgDatabase {
  Database()
      : super(
          port: 2222,
          database: 'dart_test',
          user: 'postgres',
          password: 'postgres',
          useSSL: false,
        );
}

Future<void> main() async {
  var db = Database();

  db.debugPrint = true;

  await db.companies.deleteOne('abc');

  await db.companies.insertOne(CompanyInsertRequest(
    id: 'abc',
    name: 'Minga',
    addresses: [],
  ));

  await db.accounts.deleteMany([0, 1, 2]);

  var accountId = await db.accounts.insertOne(AccountInsertRequest(
    firstName: 'Test',
    lastName: 'User',
    location: LatLng(1, 2),
    billingAddress: BillingAddress(
        name: 'Test User',
        street: 'SomeRoad 1',
        city: 'New York',
        postcode: '123'),
    companyId: 'abc',
  ));

  var account = await db.accounts.queryUserView(accountId);

  print(account!.id);

  var company = await db.companies.queryFullView('abc');

  print(company!.id);

  await db.close();
}
