import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../../../core/case_style.dart';
import '../../schema.dart';
import '../table_element.dart';
import '../../utils.dart';
import 'column_element.dart';

class FieldColumnElement extends ColumnElement with NamedColumnElement {
  @override
  final FieldElement parameter;

  late final bool isAutoIncrement;

  FieldColumnElement(this.parameter, TableElement parentTable, BuilderState state) : super(parentTable, state) {
    isAutoIncrement = (autoIncrementChecker.firstAnnotationOf(parameter) ??
        autoIncrementChecker.firstAnnotationOf(parameter.getter ?? parameter)) !=
        null;

    if (isAutoIncrement && !parameter.type.isDartCoreInt) {
      throw 'The following field is annotated with @AutoIncrement() but has an unallowed type:\n'
          '  - "${parameter.getDisplayString(withNullability: true)}" in class "${parentTable.element
          .getDisplayString(withNullability: true)}"\n'
          'A field annotated with @AutoIncrement() must be of type int.';
    }
  }

  @override
  void checkConverter() {
    if (converter != null) {
      var type = converter!.type as InterfaceType;
      var converterType = type.superclass!.typeArguments[0];

      if (dataType != converterType) {
        throw 'The following field is annotated with @UseConverter(...) with a custom converter '
            'that has a different type than the field:\n'
            '  - Field "${parameter.getDisplayString(withNullability: true)}" in class "${parentTable.element.getDisplayString(withNullability: true)}"\n'
            '  - Converter "${converter!.toSource()}" with type "$converterType"';
      }
    }
  }

  @override
  void checkModifiers() {
    if (modifiers.isNotEmpty) {
      print('Column field was annotated with "${modifiers.first.toSource()}", which is not supported.\n'
          '  - ${parameter.getDisplayString(withNullability: true)}');
    }
  }

  @override
  bool get isList => parameter.type.isDartCoreList;

  DartType get dataType {
    if (isList) {
      return (parameter.type as InterfaceType).typeArguments[0];
    } else {
      return parameter.type;
    }
  }

  String get dartType => dataType.getDisplayString(withNullability: false);

  @override
  String get sqlType {
    if (isAutoIncrement) {
      return 'serial';
    }
    var type = isList ? '_' : '';

    if (converter != null) {
      type += ConstantReader(converter).read('type').stringValue;
    } else {
      type += getSqlType(dataType);
    }
    return type;
  }

  @override
  String get paramName => parameter.name;

  @override
  String get columnName => state.options.columnCaseStyle.transform(parameter.name);

  @override
  bool get isNullable => parameter.type.nullabilitySuffix != NullabilitySuffix.none;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'field_column',
      'column_name': columnName,
    };
  }
}