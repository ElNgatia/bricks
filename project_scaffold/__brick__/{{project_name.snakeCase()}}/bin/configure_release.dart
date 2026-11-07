import 'dart:io';

/// Prepares the native projects for release builds and the store publishing workflows.
/// Safe to run more than once. Run from the project root after `flutter create`:
/// `dart run bin/configure_release.dart`
void main() {
  final gradle = File('android/app/build.gradle.kts');
  _enableDesugaring(gradle);
  _configureAndroidSigning(gradle);
  _declareExportCompliance(File('ios/Runner/Info.plist'));
}

/// Release builds sign with the upload key from android/key.properties or the
/// ANDROID_* environment variables CI sets, and fall back to the debug key so
/// `flutter run --release` still works on a machine without it.
void _configureAndroidSigning(File gradle) {
  if (!gradle.existsSync()) {
    stdout.writeln('! ${gradle.path} not found, skipping Android signing');
    return;
  }
  var content = gradle.readAsStringSync();
  if (content.contains('ANDROID_KEYSTORE_FILE')) {
    stdout.writeln('✓ Android release signing already configured');
    return;
  }

  const debugSigning = 'signingConfig = signingConfigs.getByName("debug")';
  if (!content.contains(debugSigning) || !content.contains('\n    buildTypes {')) {
    stderr.writeln('! Unrecognised ${gradle.path}, add the release signing config by hand (see PUBLISHING.md)');
    return;
  }

  content = '''import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

fun signingValue(propertyName: String, environmentName: String): String? {
    return keystoreProperties[propertyName]?.toString()?.takeIf { it.isNotBlank() }
        ?: System.getenv(environmentName)?.takeIf { it.isNotBlank() }
}

val releaseStoreFile = signingValue("storeFile", "ANDROID_KEYSTORE_FILE")

$content''';

  content = content.replaceFirst('\n    buildTypes {', '''
    signingConfigs {
        create("release") {
            if (releaseStoreFile != null) {
                storeFile = file(releaseStoreFile)
            }
            storePassword = signingValue("storePassword", "ANDROID_STORE_PASSWORD")
            keyAlias = signingValue("keyAlias", "ANDROID_KEY_ALIAS")
            keyPassword = signingValue("keyPassword", "ANDROID_KEY_PASSWORD")
        }
    }

    buildTypes {''');

  content = content.replaceFirstMapped(
    RegExp(r'( *)// TODO: Add your own signing config for the release build\.\n.*\n *' + RegExp.escape(debugSigning)),
    (m) => '${m[1]}signingConfig = signingConfigs.getByName(if (releaseStoreFile != null) "release" else "debug")',
  );
  content = content.replaceFirst(
    debugSigning,
    'signingConfig = signingConfigs.getByName(if (releaseStoreFile != null) "release" else "debug")',
  );

  gradle.writeAsStringSync(content);
  stdout.writeln('✓ Android release signing configured');
}

/// flutter_local_notifications needs core library desugaring, without which
/// every Android build fails its AAR metadata check.
void _enableDesugaring(File gradle) {
  if (!gradle.existsSync()) return;
  var content = gradle.readAsStringSync();
  if (content.contains('isCoreLibraryDesugaringEnabled')) {
    stdout.writeln('✓ Core library desugaring already enabled');
    return;
  }
  if (!content.contains('\n    compileOptions {')) {
    stderr.writeln('! Unrecognised ${gradle.path}, enable core library desugaring by hand');
    return;
  }
  content = content.replaceFirst(
    '\n    compileOptions {',
    '\n    compileOptions {\n        isCoreLibraryDesugaringEnabled = true',
  );
  content += '''
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
''';
  gradle.writeAsStringSync(content);
  stdout.writeln('✓ Core library desugaring enabled');
}

/// Answers App Store export compliance up front: the app only uses the
/// standard encryption (HTTPS) that is exempt from export documentation.
void _declareExportCompliance(File plist) {
  if (!plist.existsSync()) {
    stdout.writeln('! ${plist.path} not found, skipping export compliance');
    return;
  }
  final content = plist.readAsStringSync();
  if (content.contains('ITSAppUsesNonExemptEncryption')) {
    stdout.writeln('✓ iOS export compliance already declared');
    return;
  }
  final end = content.lastIndexOf('</dict>');
  if (end == -1) {
    stderr.writeln('! Unrecognised ${plist.path}, add ITSAppUsesNonExemptEncryption by hand');
    return;
  }
  plist.writeAsStringSync(
    '${content.substring(0, end)}\t<key>ITSAppUsesNonExemptEncryption</key>\n\t<false/>\n${content.substring(end)}',
  );
  stdout.writeln('✓ iOS export compliance declared');
}
