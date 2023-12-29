import 'package:dart_mappable/dart_mappable.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';

part 'author.mapper.dart';

@MappableClass()
@Model()
class Author with AuthorMappable {
  @PrimaryKey()
  final String id;
  final String firstName;
  final String lastName;

  const Author({
    required this.id,
    required this.firstName,
    required this.lastName,
  });
}
