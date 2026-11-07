import 'dart:async';

{{#use_firebase}}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
{{/use_firebase}}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/utils/provider_retry.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/strings.g.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_service.dart';

import 'app/app.dart';

{{#use_firebase}}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _initializeFirebase();
}
{{/use_firebase}}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  {{#use_firebase}}
  await _runStartupTask(_initializeFirebase);
  await _runStartupTask(_configureFirebaseTelemetry);
  if (_isFirebasePlatform && Firebase.apps.isNotEmpty) {
    await _runStartupTask(() async {
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    });
  }
  {{/use_firebase}}

  await HiveManager.instance.init();

  runApp(
    ProviderScope(
      retry: providerRetry,
      child: TranslationProvider(child: const {{project_name.pascalCase()}}App()),
    ),
  );
}

{{#use_firebase}}
Future<void> _initializeFirebase() async {
  if (!_isFirebasePlatform || Firebase.apps.isNotEmpty) return;
  // Initialize default Firebase app (requires google-services.json / GoogleService-Info.plist)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init bypassed: $e');
  }
}

Future<void> _configureFirebaseTelemetry() async {
  if (!_isFirebasePlatform || Firebase.apps.isEmpty) return;

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    unawaited(
      FirebaseCrashlytics.instance
          .recordFlutterFatalError(details)
          .catchError((_) {}),
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(
      FirebaseCrashlytics.instance
          .recordError(error, stack, fatal: true)
          .catchError((_) {}),
    );
    return true;
  };
}

bool get _isFirebasePlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}
{{/use_firebase}}

Future<void> _runStartupTask(Future<void> Function() task) async {
  try {
    await task();
  } catch (error, stackTrace) {
    debugPrint('Startup task failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

