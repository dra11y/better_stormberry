import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:magic_orm_annotations/magic_orm_annotations.dart';
import 'package:source_gen/source_gen.dart';

import '../global_options.dart';
import '../utils.dart';

/// BUILD STEP 1:
/// Add `part 'model.relation.dart';` to each model file forwhich
/// you want to build a `RelationInfo` meta class.
class RelationInfoBuilder extends PartBuilder {
  RelationInfoBuilder(BuilderOptions options)
      : super([RelationInfoGenerator(options)], '.relation.dart',
            options: options);
}

class RelationInfoGenerator extends Generator {
  final GlobalOptions options;

  RelationInfoGenerator(BuilderOptions options)
      : options = GlobalOptions.parse(options.config);

  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final partFile = buildStep.allowedOutputs.first.pathSegments.last;
    final hasPartDirective = library.allElements.whereType<PartElement>().any(
        (p) =>
            (p.uri as DirectiveUriWithSource).relativeUri.pathSegments.last ==
            partFile);

    // Quietly skip generation if lacking `part '{name}.relation.dart';` directive.
    if (!hasPartDirective) {
      return null;
    }

    final models = library
        .annotatedWith(modelChecker)
        .map((a) => a.element as ClassElement);

    if (models.isEmpty) {
      return null;
    }

    final emitter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final generated = Library(
      (b) => b
        ..body.addAll([
          for (final model in models)
            Class(
              (b) => b
                ..name = '\$${model.name}${(RelationInfo)}'
                ..extend = referType(RelationInfo)
                ..fields.addAll([
                  for (final field in model.fields)
                    if (field.metadata.any((m) => anyRelationChecker
                        .isExactly(m.element!.enclosingElement!)))
                      Field((f) => f
                        ..type = refer('bool')
                        ..name = '${field.name}Loaded'
                        ..modifier = FieldModifier.final$
                        ..docs.add(
                            '/// Whether the `${field.type} ${field.name}` relation has been loaded in this `${model.name}` instance.')),
                ])
                ..constructors.add(
                  Constructor(
                    (c) => c
                      ..constant = true
                      ..optionalParameters.addAll(
                        b.fields.build().map(
                              (f) => Parameter(
                                (p) => p
                                  ..named = true
                                  ..toThis = true
                                  ..name = f.name
                                  ..defaultTo = Code('false'),
                              ),
                            ),
                      ),
                  ),
                ),
            ),
        ]),
    ).accept(emitter).toString();

    return generated;
  }
}
