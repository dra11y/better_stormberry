import '../core/case_style.dart';

/// The global builder options from the build.yaml file
class GlobalOptions {
  CaseStyle? tableCaseStyle;
  CaseStyle? columnCaseStyle;
  int lineLength;

  GlobalOptions.parse(Map<String, dynamic> options)
      : tableCaseStyle = CaseStyle.fromString(options['tableCaseStyle'] as String? ??
            options['table_case_style'] as String? ??
            'snakeCase'),
        columnCaseStyle = CaseStyle.fromString(options['columnCaseStyle'] as String? ??
            options['column_case_style'] as String? ??
            'snakeCase'),
        lineLength = options['lineLength'] as int? ?? options['line_length'] as int? ?? 100;
}
