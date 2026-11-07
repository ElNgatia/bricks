import 'dart:io';

/// Standalone CLI scaffold generator for feature-first Flutter projects.
/// Can be executed with: `dart run bin/scaffold.dart`
void main(List<String> args) async {
  stdout.writeln('========================================================');
  stdout.writeln('     Flutter Project Scaffolder (Dart CLI)              ');
  stdout.writeln('========================================================\n');

  final projectName = _prompt('Project name (snake_case)', defaultValue: 'my_app');
  final projectDescription = _prompt('Project description', defaultValue: 'A new Flutter application.');
  final orgName = _prompt('Organization ID (reverse domain)', defaultValue: 'com.example');
  final apiBaseUrl = _prompt('API Base URL', defaultValue: 'https://api.example.com/api/v1');
  final featuresStr = _prompt('Features (comma-separated, snake_case)', defaultValue: 'auth,home');
  final useFirebaseStr = _prompt('Include Firebase? (y/n)', defaultValue: 'y');
  final useBiometricsStr = _prompt('Include Biometrics? (y/n)', defaultValue: 'y');
  final flutterVersion = _prompt('Flutter version (.fvmrc)', defaultValue: '3.44.8');

  final useFirebase = useFirebaseStr.toLowerCase().startsWith('y');
  final useBiometrics = useBiometricsStr.toLowerCase().startsWith('y');

  final scriptDir = File(Platform.script.toFilePath()).parent.parent;
  final templateRoot = Directory('${scriptDir.path}/__brick__/{{project_name.snakeCase()}}');
  final targetDir = Directory(projectName);

  if (!templateRoot.existsSync()) {
    stderr.writeln('Error: Template directory not found at: ${templateRoot.path}');
    exit(1);
  }

  stdout.writeln('\nGenerating project "$projectName" in ${targetDir.absolute.path}...');
  targetDir.createSync(recursive: true);

  final variables = <String, dynamic>{
    'project_name': projectName,
    'project_description': projectDescription,
    'org_name': orgName,
    'api_base_url': apiBaseUrl,
    'use_firebase': useFirebase,
    'use_biometrics': useBiometrics,
    'flutter_version': flutterVersion,
    'sdk_constraint': '^3.12.0',
  };

  _copyAndProcess(templateRoot, targetDir, variables);

  stdout.writeln('\n✓ Project files copied and templated.');

  stdout.writeln('\nInitializing native platforms (flutter create)...');
  try {
    final proc = await Process.run(
      'flutter',
      ['create', '--org', orgName, '--project-name', projectName, '.'],
      workingDirectory: targetDir.path,
    );
    if (proc.exitCode == 0) {
      stdout.writeln('✓ Native project runners created.');
    }
  } catch (e) {
    stdout.writeln('! flutter create skipped or not on PATH ($e).');
  }

  final features = featuresStr
      .split(',')
      .map((name) => name.trim().toLowerCase())
      .where((name) => name.isNotEmpty && name != 'auth' && name != 'home')
      .toSet();
  for (final feature in features) {
    await Process.run('dart', ['bin/add_feature.dart', feature], workingDirectory: targetDir.path);
  }

  stdout.writeln('\n========================================================');
  stdout.writeln('Scaffolding complete! Next steps:');
  stdout.writeln('  cd $projectName');
  stdout.writeln('  flutter pub get');
  stdout.writeln('  dart run slang');
  stdout.writeln('  dart run build_runner build --delete-conflicting-outputs');
  stdout.writeln('  flutter run');
  stdout.writeln('========================================================\n');
}

String _prompt(String message, {required String defaultValue}) {
  stdout.write('$message [$defaultValue]: ');
  final input = stdin.readLineSync()?.trim();
  if (input == null || input.isEmpty) return defaultValue;
  return input;
}

void _copyAndProcess(
  Directory source,
  Directory destination,
  Map<String, dynamic> vars,
) {
  for (final entity in source.listSync(recursive: false)) {
    final relativePath = entity.path.substring(source.path.length + 1);

    if (entity is Directory) {
      final newDir = Directory('${destination.path}/$relativePath');
      newDir.createSync(recursive: true);
      _copyAndProcess(entity, newDir, vars);
    } else if (entity is File) {
      final content = entity.readAsStringSync();
      final processed = _processMustache(content, vars);
      final destFile = File('${destination.path}/$relativePath');
      destFile.parent.createSync(recursive: true);
      destFile.writeAsStringSync(processed);
    }
  }
}

String _toSnakeCase(String str) {
  return str.replaceAllMapped(RegExp(r'([A-Z])'), (m) => '_${m[1]?.toLowerCase()}').trim().replaceAll(RegExp(r'^_+'), '');
}

String _toPascalCase(String str) {
  return str.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join();
}

String _toTitleCase(String str) {
  return str.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
}

String _processMustache(String template, Map<String, dynamic> vars) {
  var result = template;
  final projectName = vars['project_name'] as String;

  // Replacements
  result = result.replaceAll('{{project_name.snakeCase()}}', _toSnakeCase(projectName));
  result = result.replaceAll('{{project_name.pascalCase()}}', _toPascalCase(projectName));
  result = result.replaceAll('{{project_name.titleCase()}}', _toTitleCase(projectName));
  result = result.replaceAll('{{project_name}}', projectName);
  result = result.replaceAll('{{project_description}}', vars['project_description']?.toString() ?? '');
  result = result.replaceAll('{{org_name}}', vars['org_name']?.toString() ?? '');
  result = result.replaceAll('{{api_base_url}}', vars['api_base_url']?.toString() ?? '');
  result = result.replaceAll('{{flutter_version}}', vars['flutter_version']?.toString() ?? '3.44.8');
  result = result.replaceAll('{{sdk_constraint}}', vars['sdk_constraint']?.toString() ?? '^3.12.0');

  // Conditionals
  result = _handleSection(result, 'use_firebase', vars['use_firebase'] == true);
  result = _handleSection(result, 'use_biometrics', vars['use_biometrics'] == true);

  return result;
}

String _handleSection(String content, String sectionName, bool condition) {
  final pattern = RegExp(
    '\\{\\{#$sectionName\\}\\}([\\s\\S]*?)\\{\\{/$sectionName\\}\\}',
    multiLine: true,
  );

  return content.replaceAllMapped(pattern, (match) {
    return condition ? match.group(1) ?? '' : '';
  });
}

