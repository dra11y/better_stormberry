// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'author.dart';

class AuthorMapper extends ClassMapperBase<Author> {
  AuthorMapper._();

  static AuthorMapper? _instance;
  static AuthorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthorMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Author';

  static String _$id(Author v) => v.id;
  static const Field<Author, String> _f$id = Field('id', _$id);
  static String _$firstName(Author v) => v.firstName;
  static const Field<Author, String> _f$firstName =
      Field('firstName', _$firstName);
  static String _$lastName(Author v) => v.lastName;
  static const Field<Author, String> _f$lastName =
      Field('lastName', _$lastName);

  @override
  final MappableFields<Author> fields = const {
    #id: _f$id,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
  };

  static Author _instantiate(DecodingData data) {
    return Author(
        id: data.dec(_f$id),
        firstName: data.dec(_f$firstName),
        lastName: data.dec(_f$lastName));
  }

  @override
  final Function instantiate = _instantiate;

  static Author fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Author>(map);
  }

  static Author fromJson(String json) {
    return ensureInitialized().decodeJson<Author>(json);
  }
}

mixin AuthorMappable {
  String toJson() {
    return AuthorMapper.ensureInitialized().encodeJson<Author>(this as Author);
  }

  Map<String, dynamic> toMap() {
    return AuthorMapper.ensureInitialized().encodeMap<Author>(this as Author);
  }

  AuthorCopyWith<Author, Author, Author> get copyWith =>
      _AuthorCopyWithImpl(this as Author, $identity, $identity);
  @override
  String toString() {
    return AuthorMapper.ensureInitialized().stringifyValue(this as Author);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            AuthorMapper.ensureInitialized()
                .isValueEqual(this as Author, other));
  }

  @override
  int get hashCode {
    return AuthorMapper.ensureInitialized().hashValue(this as Author);
  }
}

extension AuthorValueCopy<$R, $Out> on ObjectCopyWith<$R, Author, $Out> {
  AuthorCopyWith<$R, Author, $Out> get $asAuthor =>
      $base.as((v, t, t2) => _AuthorCopyWithImpl(v, t, t2));
}

abstract class AuthorCopyWith<$R, $In extends Author, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? firstName, String? lastName});
  AuthorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthorCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Author, $Out>
    implements AuthorCopyWith<$R, Author, $Out> {
  _AuthorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Author> $mapper = AuthorMapper.ensureInitialized();
  @override
  $R call({String? id, String? firstName, String? lastName}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (firstName != null) #firstName: firstName,
        if (lastName != null) #lastName: lastName
      }));
  @override
  Author $make(CopyWithData data) => Author(
      id: data.get(#id, or: $value.id),
      firstName: data.get(#firstName, or: $value.firstName),
      lastName: data.get(#lastName, or: $value.lastName));

  @override
  AuthorCopyWith<$R2, Author, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AuthorCopyWithImpl($value, $cast, t);
}
