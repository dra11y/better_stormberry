import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
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
    final state = await buildStep.fetchResource(schemaResource);
    if (state.hasError) {
      return;
    }
    try {
      if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
        return;
      }
      final library = await buildStep.inputLibrary;
      await analyze(state, library, buildStep.inputId);
    } catch (e, st) {
      state.hasError = true;
      print('\x1B[31mFailed to analyze database schema:\n\n$e\x1B[0m\n');
      print(st);
      return;
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['___']
      };

  Future<void> analyze(
      SchemaState state, LibraryElement library, AssetId assetId) async {
    if (state.hasAsset(assetId)) return;

    final asset = state.createForAsset(assetId);
    final builderState = BuilderState(options, state, asset);

    final reader = LibraryReader(library);

    final databases = reader.annotatedWith(databaseChecker);

    for (final database in databases) {
      // print('database: $database');
      // print('annotation: ${database.annotation}');
      final modelsReader = database.annotation.read('models');
      if (!modelsReader.isList) {
        throw Exception('No models found!');
      }
      final models = modelsReader.listValue;

      for (final model in models) {
        final element = model.toTypeValue()!.element!;
        final ElementAnnotation? elementAnnotation = element.metadata
            .firstWhereOrNull((a) =>
                a.element is ConstructorElement &&
                modelChecker.isExactly(a.element!.enclosingElement!));
        if (elementAnnotation == null) {
          throw Exception('@Model() annotation not found on ${element.name}.'
              ' Add @Model() annotation.');
        }
        if (element is! ClassElement) {
          throw Exception('@Model: ${element.name} is not a ClassElement!'
              ' @Model() can only be used on constructable classes.');
        }
        if (element.isAbstract) {
          throw Exception('@Model: ${element.name} is abstract!'
              ' Remove `abstract` from `${element.getDisplayString(withNullability: false)}`.');
        }
        if (element.unnamedConstructor == null) {
          throw Exception('@Model: ${element.name} has no unnamed constructor!'
              ' Give ${element.name} a valid unnamed constructor.');
        }
        final annotationValue = elementAnnotation.computeConstantValue()!;
        final annotation = ConstantReader(annotationValue);
        final tableElement = TableElement(
          element,
          annotation,
          builderState,
        );
        asset.tables[element] = tableElement;
      }
    }

    final packageName = library.source.uri.pathSegments.first;

    for (final import in library.importedLibraries) {
      final libUri = import.source.uri;
      if (!isPackage(packageName, libUri)) {
        continue;
      }

      await analyze(state, import, AssetId.resolve(libUri));
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
