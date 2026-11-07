import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final projectName = context.vars['project_name'] as String;
  final orgName = context.vars['org_name'] as String? ?? 'com.example';
  final progress =
      context.logger.progress('Configuring Flutter project: $projectName');

  final projectDir = Directory(projectName);
  if (!projectDir.existsSync()) {
    progress.fail('Project directory not found: $projectName');
    return;
  }

  // Create native platforms using flutter create
  final flutterCreate = await Process.run(
    'flutter',
    [
      'create',
      '--org',
      orgName,
      '--project-name',
      projectName,
      '.',
    ],
    workingDirectory: projectDir.path,
  );

  if (flutterCreate.exitCode != 0) {
    context.logger.warn(
        'Could not run flutter create automatically (run it manually if needed).');
  }

  // Run pub get
  final pubGet = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: projectDir.path,
  );
  if (pubGet.exitCode == 0) {
    for (final feature in _extraFeatures(context.vars['features'])) {
      await Process.run(
        'dart',
        ['run', 'bin/add_feature.dart', feature],
        workingDirectory: projectDir.path,
      );
    }
    context.logger.info('Running slang code generation...');
    await Process.run('dart', ['run', 'slang'],
        workingDirectory: projectDir.path);
  }

  progress.complete('Project scaffold created successfully!');
  context.logger.info('\nNext steps:');
  context.logger.info('  cd $projectName');
  context.logger.info('  flutter pub get');
  context.logger.info('  dart run slang');
  context.logger
      .info('  dart run build_runner build --delete-conflicting-outputs');
  context.logger.info('  flutter run\n');
}

/// Features beyond the built-in auth and home, from a list or comma-separated string.
List<String> _extraFeatures(Object? raw) {
  final names = raw is List ? raw.map((e) => '$e') : '${raw ?? ''}'.split(',');
  return names
      .map((name) => name.trim().toLowerCase())
      .where((name) => name.isNotEmpty && name != 'auth' && name != 'home')
      .toSet()
      .toList();
}
