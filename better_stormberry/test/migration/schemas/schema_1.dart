import 'package:better_stormberry/better_stormberry.dart';

part 'schema_1.schema.dart';

@Model()
abstract class Author {
  @PrimaryKey()
  String get id;

  String get name;
}

@Model()
abstract class Book {
  @AutoIncrement()
  @PrimaryKey()
  int get id;

  String get title;
  bool get isBestSelling;

  Author get author;
}
