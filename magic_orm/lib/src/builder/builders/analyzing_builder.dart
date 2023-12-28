import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';
import '../elements/table_element.dart';
import '../global_options.dart';
import '../schema.dart';
import '../utils.dart';

/// Builder that analyzes the database schema
class AnalyzingBuilder implements Builder {
  /// The global options defined in the 'build.yaml' file
  late GlobalOptions options;

  AnalyzingBuilder(BuilderOptions options)
      : options = GlobalOptions.parse(options.config);

  @override
  Future<void> build(BuildStep buildStep) async {
    try {
      if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
        return;
      }
      var library = await buildStep.inputLibrary;
      SchemaState schema = await buildStep.fetchResource(schemaResource);
      await analyze(schema, library, buildStep.inputId);
    } catch (e, st) {
      print('\x1B[31mFailed to build database schema:\n\n$e\x1B[0m\n');
      print(st);
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['___']
      };

  Future<void> analyze(
      SchemaState schema, LibraryElement library, AssetId assetId) async {
    if (schema.hasAsset(assetId)) return;

    var asset = schema.createForAsset(assetId);
    var builderState = BuilderState(options, schema, asset);

    var reader = LibraryReader(library);

    var databases = reader.annotatedWith(databaseChecker);

    for (final database in databases) {
      // print('database: $database');
      // print('annotation: ${database.annotation}');
      final models = database.annotation.read('models').listValue;

      for (final model in models) {
        final element = model.toTypeValue()!.element!;
        final ElementAnnotation? elementAnnotation = element.metadata
            .firstWhereOrNull((a) =>
                a.element is ConstructorElement &&
                modelChecker.isExactly(a.element!.enclosingElement!));
        if (elementAnnotation == null) {
          throw Exception('@Model annotation not found on $model.');
        }
        final annotationValue = elementAnnotation.computeConstantValue()!;
        final annotation = ConstantReader(annotationValue);
        asset.tables[element] = TableElement(
          element as ClassElement,
          annotation,
          builderState,
        );
      }
    }

    if (asset.tables.isNotEmpty) {
      print('asset.tables: ${asset.tables}');
    }

    // var tables = reader.annotatedWith(modelChecker);

    // for (var table in tables) {
    //   asset.tables[table.element] = TableElement(
    //     table.element as ClassElement,
    //     table.annotation,
    //     builderState,
    //   );
    // }

    var packageName = library.source.uri.pathSegments.first;

    for (var import in library.importedLibraries) {
      var libUri = import.source.uri;
      if (!isPackage(packageName, libUri)) {
        continue;
      }

      await analyze(schema, import, AssetId.resolve(libUri));
    }
  }

  bool isPackage(String packageName, Uri lib) {
    if (lib.scheme == 'package' || lib.scheme == 'asset') {
      return lib.pathSegments.first == packageName;
    } else {
      return false;
    }
  }
}
