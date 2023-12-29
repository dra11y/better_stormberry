import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' hide LibraryBuilder;
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

import '../global_options.dart';
import '../utils.dart';

const String exportsFile = 'models.export.dart';

/// BUILD STEP 2: Generate `List<Type> models` export for all models in shared
/// project as `models.export.dart` for import into server/client projects.
class ModelsExporterBuilder extends Builder {
  ModelsExporterBuilder(BuilderOptions options)
      : options = GlobalOptions.parse(options.config);

  static const $lib$ = r'$lib$';

  static const String annotationsUri =
      'package:magic_orm_annotations/magic_orm_annotations.dart';

  final GlobalOptions options;

  @override
  Future<void> build(BuildStep buildStep) async {
    final modelState = await buildStep.fetchResource<ModelState>(modelResource);

    LibraryReader? lastReader;

    // Loop through all libraries in the project and collect models.
    await for (final input in buildStep.findAssets(Glob('**/*.dart'))) {
      final isLibrary = await buildStep.resolver.isLibrary(input);
      if (!isLibrary) {
        continue;
      }
      final library = await buildStep.resolver.libraryFor(input);
      final reader = LibraryReader(library);
      lastReader = reader;
      try {
        await collectModels(modelState, reader, buildStep);
      } catch (e, st) {
        print('\x1B[31mFailed to collect models from $library:\n\n$e\x1B[0m\n');
        print(st);
      }
    }

    // Skip this step if no models in the current project.
    if (modelState.models.isEmpty) {
      return;
    }

    final gen = ModelExportsGenerator(options);

    final modelExports = await gen.generate(lastReader!, buildStep);

    final exportsId = AssetId(buildStep.inputId.package, 'lib/$exportsFile');
    await buildStep.writeAsString(exportsId, modelExports);
  }

  Future<void> collectModels(
      ModelState state, LibraryReader library, BuildStep buildStep) async {
    final models = library.annotatedWith(modelChecker);
    state.models.addAll({
      for (final model in models)
        model.element.librarySource!.uri: model.element as InterfaceElement,
    });
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        $lib$: ['models.export.dart'],
      };
}

class ModelExportsGenerator extends Generator {
  final GlobalOptions options;
  ModelExportsGenerator(this.options);

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final modelState = await buildStep.fetchResource<ModelState>(modelResource);

    final emitter = DartEmitter.scoped(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    // Generate a single library file with list of all model types.
    final generated = Library(
      (b) => b
        ..comments.addAll([
          ...generatedComments,
          '',
          'Define your database with the [@MagicDatabase] annotation using',
          'these models as follows:',
          '',
          '```',
          'import \'package:${buildStep.inputId.package}/models.export.dart\';',
          '',
          '@MagicDatabase(models: models)',
          'class Database extends PgDatabase { ... }',
          '```',
        ])
        ..body.add(
          declareConst('models', type: referType(List<Type>))
              .assign(
                literalList(modelState.refs),
              )
              .statement,
        ),
    ).accept(emitter).toString();

    return DartFormatter(pageWidth: options.lineLength).format(generated);
  }
}

final modelResource = Resource<ModelState>(() => ModelState());

class ModelState {
  final Map<Uri, InterfaceElement> models = {};

  // Get a list of model type refs with relative Uris.
  Iterable<Reference> get refs =>
      models.entries.map((m) => refer(m.value.name, m.key.relative));
}
