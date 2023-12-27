// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'book.dart';

class BookMapper extends ClassMapperBase<Book> {
  BookMapper._();

  static BookMapper? _instance;
  static BookMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BookMapper._());
      AuthorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Book';

  static String _$id(Book v) => v.id;
  static const Field<Book, String> _f$id = Field('id', _$id);
  static String _$title(Book v) => v.title;
  static const Field<Book, String> _f$title = Field('title', _$title);
  static Author _$author(Book v) => v.author;
  static const Field<Book, Author> _f$author = Field('author', _$author);

  @override
  final MappableFields<Book> fields = const {
    #id: _f$id,
    #title: _f$title,
    #author: _f$author,
  };

  static Book _instantiate(DecodingData data) {
    return Book(
        id: data.dec(_f$id),
        title: data.dec(_f$title),
        author: data.dec(_f$author));
  }

  @override
  final Function instantiate = _instantiate;

  static Book fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Book>(map);
  }

  static Book fromJson(String json) {
    return ensureInitialized().decodeJson<Book>(json);
  }
}

mixin BookMappable {
  String toJson() {
    return BookMapper.ensureInitialized().encodeJson<Book>(this as Book);
  }

  Map<String, dynamic> toMap() {
    return BookMapper.ensureInitialized().encodeMap<Book>(this as Book);
  }

  BookCopyWith<Book, Book, Book> get copyWith =>
      _BookCopyWithImpl(this as Book, $identity, $identity);
  @override
  String toString() {
    return BookMapper.ensureInitialized().stringifyValue(this as Book);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            BookMapper.ensureInitialized().isValueEqual(this as Book, other));
  }

  @override
  int get hashCode {
    return BookMapper.ensureInitialized().hashValue(this as Book);
  }
}

extension BookValueCopy<$R, $Out> on ObjectCopyWith<$R, Book, $Out> {
  BookCopyWith<$R, Book, $Out> get $asBook =>
      $base.as((v, t, t2) => _BookCopyWithImpl(v, t, t2));
}

abstract class BookCopyWith<$R, $In extends Book, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AuthorCopyWith<$R, Author, Author> get author;
  $R call({String? id, String? title, Author? author});
  BookCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BookCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Book, $Out>
    implements BookCopyWith<$R, Book, $Out> {
  _BookCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Book> $mapper = BookMapper.ensureInitialized();
  @override
  AuthorCopyWith<$R, Author, Author> get author =>
      $value.author.copyWith.$chain((v) => call(author: v));
  @override
  $R call({String? id, String? title, Author? author}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (title != null) #title: title,
        if (author != null) #author: author
      }));
  @override
  Book $make(CopyWithData data) => Book(
      id: data.get(#id, or: $value.id),
      title: data.get(#title, or: $value.title),
      author: data.get(#author, or: $value.author));

  @override
  BookCopyWith<$R2, Book, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BookCopyWithImpl($value, $cast, t);
}
