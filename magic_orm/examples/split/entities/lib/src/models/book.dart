import 'package:dart_mappable/dart_mappable.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

import 'author.dart';

part 'book.mapper.dart';

@MappableClass()
@Model()
class Book with BookMappable {
  @PrimaryKey()
  final String id;
  final String title;
  final Author author;

  const Book({
    required this.id,
    required this.title,
    required this.author,
  });
}
