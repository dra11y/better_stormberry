import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import '../../core/case_style.dart';
import '../schema.dart';
import '../utils.dart';
import 'column/column_element.dart';
import 'column/field_column_element.dart';
import 'column/foreign_column_element.dart';
import 'column/join_column_element.dart';
import 'column/reference_column_element.dart';
import 'index_element.dart';
import 'join_table_element.dart';

extension EnumType on DartType {
  bool get isEnum => TypeChecker.fromRuntime(Enum).isAssignableFromType(this);
}

class TableElement {
  final ClassElement element;
  final ConstantReader annotation;
  final BuilderState state;

  late bool isAbstract;
  late String repoName;
  late String tableName;
  late FieldElement? primaryKeyParameter;
  // late Map<String, ViewElement> views;
  late List<IndexElement> indexes;
  ConstantReader? meta;

  TableElement(this.element, this.annotation, this.state) {
    tableName = _getTableName();
    repoName = _getRepoName();
    isAbstract = element.isAbstract;

    primaryKeyParameter = element.fields
        .where((p) =>
            primaryKeyChecker.hasAnnotationOf(p) ||
            primaryKeyChecker.hasAnnotationOf(p.getter ?? p))
        .firstOrNull;

    // views = {};

    // for (final o in annotation.read('views').listValue) {
    //   final name = ViewElement.nameOf(o);
    //   views[name] = ViewElement(this, name);
    // }

    // if (views.isEmpty) {
    //   views[ViewElement.defaultName] = ViewElement(this);
    // }

    indexes = annotation.read('indexes').listValue.map((o) {
      return IndexElement(this, o);
    }).toList();

    if (!annotation.read('meta').isNull) {
      meta = annotation.read('meta');
    }
  }

  String _getTableName({bool singular = false}) {
    if (!annotation.read('tableName').isNull) {
      return annotation.read('tableName').stringValue;
    }

    return state.options.tableCaseStyle
        .transform(_getRepoName(singular: singular));
  }

  String _getRepoName({bool singular = false}) {
    String name = element.name;
    if (!singular) {
      if (element.name.endsWith('s')) {
        name += 'es';
      } else if (element.name.endsWith('y')) {
        name = '${name.substring(0, name.length - 1)}ies';
      } else {
        name += 's';
      }
    }
    return CaseStyle.camelCase.transform(name);
  }

  List<ColumnElement> columns = [];

  FieldColumnElement? get primaryKeyColumn => primaryKeyParameter != null
      ? columns
          .whereType<FieldColumnElement>()
          .where((c) => c.parameter == primaryKeyParameter)
          .firstOrNull
      : null;

  late List<FieldElement> allFields = () {
    // Only include overridden fields once, otherwise we get duplicates!
    final List<String> overriddenNames =
        element.fields.map((f) => f.name).toList();
    return element.fields
        .cast<FieldElement>()
        .followedBy(
          element.allSupertypes.whereNot(
                  // Do not include fields of Dart core supertypes.
                  (t) => t.isDartCoreObject).expand(
                (t) => t.element.fields.whereNot(
                  // Exclude overridden fields already included.
                  (f) => overriddenNames.contains(f.name),
                ),
              ),
        )
        .toList();
  }();

  void prepareColumns() {
    stdout
        .writeln('\n==================== ${element.name} ====================');

    for (final param in allFields) {
      if (param.type is InvalidType) {
        throw Exception(
            'Field `${param.name}` on ${param.enclosingElement} has an invalid type.');
      }

      if (columns.any((c) => c.parameter == param)) {
        stdout.writeln('\nSKIP already defined column: $param');
        continue;
      }

      /// Skip `RelationInfo` fields.
      if (relationInfoChecker.isSuperTypeOf(param.type)) {
        stdout.writeln('\nSKIP relation info field');
        continue;
      }

      stdout.writeln('\nFIELD: ${param.type} ${param.name}');

      final isList = param.type.isDartCoreList;
      final dataType =
          isList ? (param.type as InterfaceType).typeArguments[0] : param.type;

      if (!state.schema.tables.containsKey(dataType.element)) {
        // Not a relational column.
        stdout.writeln('\t FIELD COLUMN (not relational)');
        columns.add(FieldColumnElement(param, this, state));
        continue;
      }

      final otherBuilder = state.schema.tables[dataType.element]!;

      final selfHasKey = primaryKeyParameter != null;
      final otherHasKey = otherBuilder.primaryKeyParameter != null;

      final otherParam = otherBuilder.findMatchingParam(param);
      final selfIsList = param.type.isDartCoreList;
      final otherIsList = otherParam != null
          ? otherParam.type.isDartCoreList
          : otherHasKey && !selfIsList;

      if (!selfHasKey && !otherHasKey) {
        throw 'Model ${otherBuilder.element.name} cannot have a relation to model ${element.name} because neither model'
            'has a primary key. Define a primary key for at least one of the models in a relation.';
      }

      if (selfHasKey && !otherHasKey && otherIsList) {
        throw 'Model ${otherBuilder.element.name} cannot have a many-to-'
            '${selfIsList ? 'many' : 'one'} relation to model ${element.name} without specifying a primary key.\n'
            'Either define a primary key for ${otherBuilder.element.name} or change the relation by changing field '
            '"${otherParam!.getDisplayString(withNullability: true)}" to have a non-list type.';
      }

      if (selfHasKey && otherHasKey && !selfIsList && !otherIsList) {
        final eitherNullable =
            param.type.nullabilitySuffix != NullabilitySuffix.none ||
                otherParam!.type.nullabilitySuffix != NullabilitySuffix.none;
        if (!eitherNullable) {
          throw 'Model ${otherBuilder.element.name} cannot have a one-to-one relation to model ${element.name} with '
              'both sides being non-nullable. At least one side has to be nullable, to insert one model before the other.\n'
              'However both "${element.name}.${param.name}" and "${otherBuilder.element.name}.${otherParam.name}" '
              'are non-nullable.\n'
              'Either make at least one parameter nullable or change the relation by changing one parameter to have a list type.';
        }
      }

      if (selfHasKey && otherHasKey && selfIsList && otherIsList) {
        // Many to Many

        final joinBuilder = JoinTableElement(this, otherBuilder, state);
        if (!state.schema.joinTables.containsKey(joinBuilder.tableName)) {
          state.asset.joinTables[joinBuilder.tableName] = joinBuilder;
        }

        final selfColumn =
            JoinColumnElement(param, otherBuilder, joinBuilder, this, state);
        stdout.writeln('\t MANY TO MANY JOIN: $tableName ${param.name}');

        JoinColumnElement otherColumn;
        if (param != otherParam) {
          stdout.writeln('\t OTHER = OTHER: ${otherParam?.name}');

          otherColumn = JoinColumnElement(
              otherParam!, this, joinBuilder, otherBuilder, state);
          otherColumn.referencedColumn = selfColumn;
          otherBuilder.columns.add(otherColumn);
        } else {
          stdout.writeln('\t OTHER = SELF: ${selfColumn.columnName}');

          otherColumn = selfColumn;
        }

        selfColumn.referencedColumn = otherColumn;
        columns.add(selfColumn);
        continue;
      }

      // not many-to-many

      ReferencingColumnElement selfColumn;
      stdout.writeln('\t NOT MANY-TO-MANY');

      if (otherHasKey && !selfIsList) {
        selfColumn = ForeignColumnElement(param, otherBuilder, this, state);
        stdout.writeln('\t\t otherHasKey && !selfIsList:');
      } else {
        selfColumn = ReferenceColumnElement(param, otherBuilder, this, state);
        stdout.writeln('\t\t !otherHasKey || selfIsList:');
      }
      stdout.writeln('\t\t selfColumn = $selfColumn');

      columns.add(selfColumn);

      ReferencingColumnElement otherColumn;

      if (param == otherParam) {
        // SELF REFERENCING?
        stdout.writeln('\t\t param == otherParam');

        otherColumn = selfColumn;
      } else {
        stdout.writeln('\t\t param != otherParam');

        if (selfHasKey &&
            !otherIsList &&
            (selfColumn is! ForeignColumnElement || this != otherBuilder)) {
          // BELONGS TO
          stdout.writeln('\t\t\t selfHasKey && !otherIsList ...');

          otherColumn =
              ForeignColumnElement(otherParam, this, otherBuilder, state);
        } else {
          // HAS MANY
          stdout.writeln('\t\t\t !(selfHasKey && !otherIsList ...)');
          otherColumn =
              ReferenceColumnElement(otherParam, this, otherBuilder, state);
        }
        otherBuilder.columns.add(otherColumn);
        otherColumn.referencedColumn = selfColumn;
      }
      stdout.writeln('\t\t\t otherColumn = $otherColumn');

      selfColumn.referencedColumn = otherColumn;
    }

    stdout.writeln();

    // for (final c in columns) {
    //   for (final m in c.modifiers) {
    //     final viewName = ViewElement.nameOf(m.read('name').objectValue);

    //     if (!views.containsKey(viewName)) {
    //       throw 'Model ${element.name} uses a view modifier on an unknown view \'#$viewName\'.\n'
    //           'Make sure to add this view to @Model(views: [...]).';
    //     }
    //   }
    // }
  }

  void sortColumns() {
    columns.sortBy((column) {
      String key = '';

      if (column.parameter != null) {
        // first: columns related to a model field, in declared order
        key += '0_';
        key += allFields.indexOf(column.parameter!).toString();
      } else if (column is ParameterColumnElement) {
        // then: foreign or reference columns with no field, in alphabetical order
        key += '1_';
        key += column.paramName;
      } else {
        // then: rest
        key += '2';
      }

      return key;
    });
  }

  FieldElement? findMatchingParam(FieldElement param) {
    final binding = param.binding;

    if (binding != null) {
      final bindingParam =
          allFields.where((f) => f.name == binding).firstOrNull;

      if (bindingParam == null) {
        throw 'A @BindTo() annotation was used with an incorrect target field. The following field '
            'was annotated:\n'
            '  - "${param.getDisplayString(withNullability: true)}" in class "${param.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'The binding specified a target field of:\n'
            '  - "$binding"\n'
            'which does not exist in class "${element.getDisplayString(withNullability: false)}.';
      }

      final bindingParamBinding = bindingParam.binding;

      if (bindingParamBinding == null) {
        throw 'A @BindTo() annotation was only used on one field of a relation. The following field '
            'had no binding:\n'
            '  - "${bindingParam.getDisplayString(withNullability: true)}" in class "${bindingParam.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'while the following field had a binding referring to the first field:\n'
            '  - "${param.getDisplayString(withNullability: true)}" in class ${param.enclosingElement.getDisplayString(withNullability: true)}"\n\n'
            'Make sure that both parameters specify the @BindTo() annotation referring to each other, or neither.';
      } else if (bindingParamBinding != param.name) {
        throw 'A @BindTo() annotation contained an incorrect target field. The following field '
            'had a binding:\n'
            '  - "${param.getDisplayString(withNullability: true)}" in class "${param.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'which referred to the second field:\n'
            '  - "${bindingParam.getDisplayString(withNullability: true)}" in class ${bindingParam.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'which referred to some other field "$bindingParamBinding".\n\n'
            'Make sure that both fields specify the @BindTo() annotation referring to each other, or neither.';
      }

      final type = bindingParam.type.isDartCoreList
          ? (bindingParam.type as InterfaceType).typeArguments[0]
          : bindingParam.type;

      if (type.element != param.enclosingElement) {
        throw 'A @BindTo() annotation was used incorrectly on a type. The following field '
            'had a binding:\n'
            '  - "${param.getDisplayString(withNullability: true)}" in class "${param.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'which referred to the second field:\n'
            '  - "${bindingParam.getDisplayString(withNullability: true)}" in class ${bindingParam.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'which has an incorrect type "${type.element?.getDisplayString(withNullability: false)}".\n\n'
            'Make sure that the type of the second field is set to the class of the first field.';
      }

      return bindingParam;
    }

    if (allFields.contains(param)) {
      // Select no default matching param for self relations.
      return null;
    }

    return allFields.where((p) {
      final type = p.type.isDartCoreList
          ? (p.type as InterfaceType).typeArguments[0]
          : p.type;
      if (type.element != param.enclosingElement) return false;

      final binding = p.binding;
      if (binding == param.name) {
        throw 'A @BindTo() annotation was only used on one field of a relation. The following field'
            'had no binding:\n'
            '  - "${param.getDisplayString(withNullability: true)}" in class "${param.enclosingElement.getDisplayString(withNullability: true)}"\n'
            'while the following field had a binding referring to the first field:\n'
            '  - "${p.getDisplayString(withNullability: true)}" in class ${p.enclosingElement.getDisplayString(withNullability: true)}"\n\n'
            'Make sure that both fields specify the @BindTo() annotation referring to each other, or neither.';
      }
      if (binding != null) return false;
      return true;
    }).firstOrNull;
  }

  String? getForeignKeyName({bool plural = false, String? base}) {
    if (primaryKeyColumn == null) return null;
    String name = base ?? _getTableName(singular: true);
    if (base != null && plural && name.endsWith('s')) {
      name = name.substring(0, base.length - (base.endsWith('es') ? 2 : 1));
    }
    name = state.options.columnCaseStyle
        .transform('$name-${primaryKeyColumn!.columnName}');
    if (plural) {
      name += name.endsWith('s') ? 'es' : 's';
    }
    return name;
  }

  // ConstantReader? metaFor(String name) {
  //   if (meta == null) {
  //     return null;
  //   }
  //   final views = meta!.read('views');
  //   if (!views.isNull) {
  //     final view = views.mapValue.entries
  //         .where((e) => name == e.key?.toSymbolValue())
  //         .firstOrNull
  //         ?.value;
  //     if (view != null && !view.isNull) {
  //       return ConstantReader(view);
  //     }
  //   }
  //   return meta!.read('view');
  // }

  // void analyzeViews() {
  //   for (final view in views.values) {
  //     view.analyze();
  //   }
  // }

  @override
  String toString() => '''TableElement(
    element: ${element.name},
    isAbstract: $isAbstract,
    repoName: $repoName,
    tableName: $tableName,
    primaryKeyParameter: $primaryKeyParameter,
    indexes: $indexes,
    meta: ${meta?.objectValue},
  )''';
}

extension FieldBinding on FieldElement {
  String? get binding {
    return bindToChecker
        .firstAnnotationOf(getter ?? this)
        ?.getField('name')
        ?.toSymbolValue();
  }
}
