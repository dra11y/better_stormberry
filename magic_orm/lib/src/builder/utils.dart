import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/exception/exception.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';
import 'package:source_gen/source_gen.dart';

const modelChecker = TypeChecker.fromRuntime(Model);
const typeConverterChecker = TypeChecker.fromRuntime(TypeConverter);
const primaryKeyChecker = TypeChecker.fromRuntime(PrimaryKey);
const autoIncrementChecker = TypeChecker.fromRuntime(AutoIncrement);
// const hiddenInChecker = TypeChecker.fromRuntime(HiddenIn);
// const viewedInChecker = TypeChecker.fromRuntime(ViewedIn);
// const transformedInChecker = TypeChecker.fromRuntime(TransformedIn);
const useConverterChecker = TypeChecker.fromRuntime(UseConverter);
const bindToChecker = TypeChecker.fromRuntime(BindTo);
const databaseChecker = TypeChecker.fromRuntime(MagicDatabase);
const relationInfoChecker = TypeChecker.fromRuntime(RelationInfo);

const hasManyChecker = TypeChecker.fromRuntime(HasMany);
const belongsToChecker = TypeChecker.fromRuntime(BelongsTo);
const hasRelationChecker = TypeChecker.fromRuntime(HasRelation);

extension LetExtension<T> on T {
  R let<R>(R Function(T) x) => x(this);
}

extension SymbolValue on DartObject {
  Symbol? toSymbol() => toSymbolValue()?.let((v) => Symbol(v));
}

class ModelAnnotations {
  ModelAnnotations(this.element, List<FieldElement> fields)
      : fields = {
          for (final field in fields) field: FieldAnnotations(field),
        } {
    _validateModelAnnotations();
  }

  _validateModelAnnotations() {
    final Map<MagicAnnotationType,
            List<({FieldElement field, MagicAnnotation annotation})>>
        allAnnotations = {};

    for (final field in fields.entries) {
      final annotations = field.value.annotations;
      annotations.forEach((key, value) {
        allAnnotations
            .putIfAbsent(key, () => [])
            .add((field: field.key, annotation: value));
      });
    }

    allAnnotations.forEach((type, annotations) {
      if (annotations.length < 2) {
        return;
      }

      switch (type) {
        case MagicAnnotationType.primaryKey:
          final primaryKeys =
              annotations.cast<({FieldElement field, PrimaryKey annotation})>();
          if (!primaryKeys.every((pk) => pk.annotation.multi)) {
            throw AnnotationValidationException(
                'More than one PrimaryKey declared on ${element.debugName} with'
                ' one or more not declared multi:\n\n${primaryKeys.where((pk) => !pk.annotation.multi)}.',
                source: element.source);
          }
        case MagicAnnotationType.autoIncrement:
        case MagicAnnotationType.belongsTo:
        case MagicAnnotationType.hasOne:
        case MagicAnnotationType.hasMany:
          return;
      }
    });
  }

  final ClassElement element;
  final Map<FieldElement, FieldAnnotations> fields;

  @override
  String toString() => '''$runtimeType(
    element: $element,
    fields: $fields,
  )''';
}

class FieldAnnotations {
  FieldAnnotations(this.field)
      : annotations = MagicAnnotationType.hydrateAll(field);

  final Element field;
  final Map<MagicAnnotationType, MagicAnnotation> annotations;

  bool get isEmpty => annotations.isEmpty;
  bool get isNotEmpty => annotations.isNotEmpty;

  PrimaryKey? get primaryKey =>
      annotations[MagicAnnotationType.primaryKey] as PrimaryKey?;

  AutoIncrement? get autoIncrement =>
      annotations[MagicAnnotationType.autoIncrement] as AutoIncrement?;

  BelongsTo? get belongsTo =>
      annotations[MagicAnnotationType.belongsTo] as BelongsTo?;

  HasOne? get hasOne => annotations[MagicAnnotationType.hasOne] as HasOne?;

  HasMany? get hasMany => annotations[MagicAnnotationType.hasMany] as HasMany?;

  @override
  String toString() => '$runtimeType(${[
        'field: ${field.debugName}',
        if (isEmpty) 'isEmpty: $isEmpty',
        if (primaryKey != null) primaryKey,
        if (autoIncrement != null) autoIncrement,
        if (belongsTo != null) belongsTo,
        if (hasOne != null) hasOne,
        if (hasMany != null) hasMany,
      ].join(', ')})';
}

extension ElementDebugName on Element {
  String get debugName => enclosingElement?.name != null && name != null
      ? '${enclosingElement!.name}.${name!}'
      : toString();
}

enum MagicAnnotationType {
  primaryKey(PrimaryKey, TypeChecker.fromRuntime(PrimaryKey),
      canCoexistWith: {autoIncrement}),
  autoIncrement(AutoIncrement, TypeChecker.fromRuntime(AutoIncrement)),
  belongsTo(BelongsTo, TypeChecker.fromRuntime(BelongsTo)),
  hasOne(HasOne, TypeChecker.fromRuntime(HasOne)),
  hasMany(HasMany, TypeChecker.fromRuntime(HasMany));

  // The type checker for this annotation type.
  final TypeChecker c;

  // The actual annotation type.
  final Type type;

  final Set<MagicAnnotationType> canCoexistWith;

  const MagicAnnotationType(this.type, this.c,
      {this.canCoexistWith = const {}});

  static Map<MagicAnnotationType, MagicAnnotation> hydrateAll(Element element) {
    final Map<MagicAnnotationType, MagicAnnotation> map = {};
    for (final annotation in element.metadata) {
      final type = fromAnnotation(annotation);
      if (type == null) {
        continue;
      }
      if (element is FieldElement &&
          !element.type.isDartCoreInt &&
          type == autoIncrement) {
        throw AnnotationValidationException(
            '${element.debugName} cannot have AutoIncrement because it is not of type int.',
            source: element.source!);
      }
      if (map.containsKey(type)) {
        throw TooManyElementsException(
            '${element.debugName} has more than one $type annotation, which is conflicting.',
            source: element.source!);
      }
      for (final existing in map.keys) {
        if (existing.canCoexistWith.contains(type) ||
            type.canCoexistWith.contains(existing)) {
          continue;
        }
        throw TooManyElementsException(
            '${element.debugName} has two annotations'
            ' that cannot coexist because they conflict: ${[
              type.type,
              existing.type,
            ]}.',
            source: element.source!);
      }
      map[type] = type.hydrateAnnotation(annotation);
    }
    return map;
  }

  MagicAnnotation hydrateAnnotation(ElementAnnotation annotation) {
    if (!c.isExactly(annotation.element!.enclosingElement!)) {
      throw Exception('Annotation $annotation is not hydratable as $this.');
    }
    final object = annotation.computeConstantValue();
    if (object == null) {
      throw Exception(
          'Could not get object from annotation: ${annotation.constantEvaluationErrors}');
    }
    switch (this) {
      case MagicAnnotationType.primaryKey:
        final defaults = PrimaryKey();
        final multi = object.getField('multi')?.toBoolValue();
        final order = object.getField('order')?.toIntValue();
        return PrimaryKey(
            multi: multi ?? defaults.multi, order: order ?? defaults.order);
      case MagicAnnotationType.belongsTo:
        final defaults = BelongsTo();
        final optional = object.getField('optional')?.toBoolValue();
        final primaryKey = object.getField('primaryKey')?.toSymbol();
        return BelongsTo(
            optional: optional ?? defaults.optional,
            primaryKey: primaryKey ?? defaults.primaryKey);
      case MagicAnnotationType.hasOne:
        final defaults = HasOne();
        final foreignKey = object.getField('foreignKey')?.toSymbol();
        return HasOne(foreignKey: foreignKey ?? defaults.foreignKey);
      case MagicAnnotationType.hasMany:
        final defaults = HasMany();
        final foreignKey = object.getField('foreignKey')?.toSymbol();
        return HasMany(foreignKey: foreignKey ?? defaults.foreignKey);
      case MagicAnnotationType.autoIncrement:
        return AutoIncrement();
    }
  }

  static MagicAnnotationType? fromAnnotation(ElementAnnotation annotation) {
    final element = annotation.element?.enclosingElement;
    if (element == null) {
      return null;
    }
    for (final value in values) {
      if (value.c.isExactly(element)) {
        return value;
      }
    }
    return null;
  }
}

Reference referType(Type type) => refer('$type');

const List<String> generatedComments = [
  'GENERATED CODE - DO NOT MODIFY BY HAND',
  '',
  'Generated by: magic_orm',
];

extension IterableDebugString<E> on Iterable<E> {
  String get debugString => '<$E>[\n    ${join(',\n    ')}\n]';
}

class AnalyzerException extends AnalysisException {
  AnalyzerException(super.message, {required this.source});

  final Object source;

  @override
  String toString() => '${super.toString()}\nSource: $source';
}

class TooManyElementsException extends AnalyzerException {
  TooManyElementsException(super.message, {required super.source});
}

class AnnotationValidationException extends AnalyzerException {
  AnnotationValidationException(super.message, {required super.source});
}

extension SingleOrNone<E> on Iterable<E> {
  E? singleOrNoneWhere(bool Function(E element) test,
      {String? tooManyMessage, required Object source}) {
    final matching = where((element) => test(element)).toList();
    if (matching.length > 1) {
      throw TooManyElementsException(
          '${tooManyMessage ?? 'Too many elements match'}:\n\n${matching.debugString}',
          source: source);
    }
    return matching.firstOrNull;
  }
}

extension RelativeUri on Uri {
  String get relative => pathSegments.sublist(1).join('/');
}

extension GetNode on Element {
  AstNode? getNode() {
    var result = session?.getParsedLibraryByElement(library!);
    if (result is ParsedLibraryResult) {
      return result.getElementDeclaration(this)?.node;
    } else {
      return null;
    }
  }
}

String? getAnnotationCode(
    Element annotatedElement, Type annotationType, String property) {
  var node = annotatedElement.getNode();

  NodeList<Annotation> annotations;

  if (node is VariableDeclaration) {
    var parent = node.parent?.parent;
    if (parent is FieldDeclaration) {
      annotations = parent.metadata;
    } else {
      return null;
    }
  } else if (node is Declaration) {
    annotations = node.metadata;
  } else {
    return null;
  }

  for (var annotation in annotations) {
    if (annotation.name.name == annotationType.toString()) {
      var props = annotation.arguments!.arguments
          .whereType<NamedExpression>()
          .where((e) => e.name.label.name == property);

      if (props.isNotEmpty) {
        return props.first.expression.toSource();
      }
    }
  }

  return null;
}

extension ObjectSource on DartObject {
  String toSource() {
    return ConstantReader(this).toSource();
  }
}

extension ReaderSource on ConstantReader {
  String toSource() {
    if (isLiteral) {
      if (isString) {
        return "'$literalValue'";
      } else if (isList) {
        return '[${listValue.map((o) => o.toSource()).join(', ')}]';
      }
      return literalValue!.toString();
    }

    if (isType) {
      return typeValue.getDisplayString(
          withNullability:
              typeValue.nullabilitySuffix != NullabilitySuffix.star);
    }

    var rev = revive();

    var str = '';
    if (rev.source.fragment.isNotEmpty) {
      str = rev.source.fragment;

      if (objectValue.type is InterfaceType) {
        var args = (objectValue.type as InterfaceType).typeArguments;
        if (args.isNotEmpty) {
          str +=
              '<${args.map((a) => a.getDisplayString(withNullability: true)).join(', ')}>';
        }
      }

      if (rev.accessor.isNotEmpty) {
        str += '.${rev.accessor}';
      }

      str += '(';
      var isFirst = true;

      for (var p in rev.positionalArguments) {
        if (!isFirst) {
          str += ', ';
        }
        isFirst = false;
        str += p.toSource();
      }

      for (var p in rev.namedArguments.entries) {
        if (!isFirst) {
          str += ', ';
        }
        isFirst = false;
        str += '${p.key}: ${p.value.toSource()}';
      }

      str += ')';
    } else {
      str = rev.accessor;
    }
    return str;
  }
}

String defineClassWithMeta(String className, ConstantReader? meta,
    {String? mixin}) {
  if (meta == null || meta.isNull) {
    return 'class $className${mixin != null ? ' with $mixin' : ''} {\n';
  }

  String readClause(String field, String keyword, [String? additional]) {
    var items = [
      if (!meta.read(field).isNull)
        meta.read(field).stringValue.replaceAll('{name}', className),
      if (additional != null) additional,
    ];
    return items.isEmpty ? '' : ' $keyword ${items.join(', ')}';
  }

  var annotation = meta.read('annotation').isNull
      ? ''
      : '@${meta.read('annotation').toSource()}\n';
  var extendClause = readClause('extend', 'extends');
  var withClause = readClause('mixin', 'with', mixin);
  var implementClause = readClause('implement', 'implements');
  return '${annotation}class $className$extendClause$withClause$implementClause {\n';
}
