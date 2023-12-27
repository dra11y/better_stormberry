import 'package:better_stormberry/better_stormberry.dart';
import 'package:better_stormberry_annotations/better_stormberry_annotations.dart';

part 'schema_2.schema.dart';

@Model()
abstract class Author {
  @PrimaryKey()
  String get id;

  String get name;
}

@Model(indexes: [
  PgTableIndex(name: 'rating_index', columns: ['rating'])
])
abstract class Book {
  @AutoIncrement()
  @PrimaryKey()
  int get id;

  String get title;
  bool get isBestSelling;

  int get rating;

  Author get author;
}
