import 'dart:io';

/// Feature scaffold generator: adds a new domain feature adhering to the scaffold's clean architecture.
/// Run from the project root: `dart run bin/add_feature.dart <feature_name>`
void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run bin/add_feature.dart <feature_name_snake_case>');
    exit(1);
  }

  final featureName = args[0].toLowerCase().trim();
  final pascalName = featureName.split('_').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join();
  final camelName = pascalName.isEmpty ? featureName : pascalName[0].toLowerCase() + pascalName.substring(1);
  final titleName = featureName.split('_').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ');

  stdout.writeln('Scaffolding feature "$featureName" ($pascalName)...');

  final basePath = 'lib/features/$featureName';

  final dirs = [
    '$basePath/data/datasources',
    '$basePath/data/models',
    '$basePath/data/repositories',
    '$basePath/domain/entities',
    '$basePath/domain/repositories',
    '$basePath/i18n',
    '$basePath/presentation/providers',
    '$basePath/presentation/screens',
    '$basePath/presentation/widgets',
    'test/features/$featureName',
  ];

  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }

  // 1. i18n file: <featureCamelCase>_en.i18n.json (slang skips underscores before _en)
  File('$basePath/i18n/${camelName}_en.i18n.json').writeAsStringSync('''{
  "terms": {
    "$featureName": {
      "singular": "$titleName"
    }
  },
  "title": "$titleName",
  "empty": "No $titleName records found.",
  "actions": {
    "create": "New $titleName"
  }
}
''');

  // 2. Domain repository interface
  File('$basePath/domain/repositories/${featureName}_repository.dart').writeAsStringSync('''abstract class ${pascalName}Repository {
  Future<List<dynamic>> getItems();
}
''');

  // 3. Screen
  File('$basePath/presentation/screens/${featureName}_screen.dart').writeAsStringSync('''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${pascalName}Screen extends ConsumerWidget {
  static const path = '/$featureName';
  static const name = '$featureName';

  const ${pascalName}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$titleName'),
      ),
      body: const Center(
        child: Text('$titleName Screen'),
      ),
    );
  }
}
''');

  // 4. Barrel export
  File('$basePath/$featureName.dart').writeAsStringSync('''export 'presentation/screens/${featureName}_screen.dart';
''');

  stdout.writeln('✓ Feature "$featureName" created at $basePath');
  stdout.writeln('Next steps:');
  stdout.writeln('  1. Add route to lib/app/router/app_router.dart:');
  stdout.writeln('     GoRoute(');
  stdout.writeln('       path: ${pascalName}Screen.path,');
  stdout.writeln('       name: ${pascalName}Screen.name,');
  stdout.writeln('       builder: (context, state) => const ${pascalName}Screen(),');
  stdout.writeln('     ),');
  stdout.writeln('  2. Run: dart run slang (to regenerate translations)');
}

