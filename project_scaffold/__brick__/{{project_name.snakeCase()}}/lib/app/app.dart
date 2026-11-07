import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/app/core/network/session_expiry.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology_provider.dart';
import 'package:{{project_name.snakeCase()}}/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/theme_notifier.dart';
import 'package:{{project_name.snakeCase()}}/app/theme/theme_v2.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/sources/auth_local_source.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/screens/login_screen.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/presentation/providers/login_provider.dart';

class {{project_name.pascalCase()}}App extends ConsumerStatefulWidget {
  const {{project_name.pascalCase()}}App({super.key});

  @override
  ConsumerState<{{project_name.pascalCase()}}App> createState() => _{{project_name.pascalCase()}}AppState();
}

final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class _{{project_name.pascalCase()}}AppState extends ConsumerState<{{project_name.pascalCase()}}App>
    with WidgetsBindingObserver {
  StreamSubscription<void>? _sessionExpirySub;
  bool _handlingExpiry = false;

  @override
  void initState() {
    super.initState();
    _sessionExpirySub = ref
        .read(sessionExpiryProvider)
        .stream
        .listen((_) => _onSessionExpired());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(terminologyControllerProvider.notifier).refresh());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionExpirySub?.cancel();
    super.dispose();
  }

  Future<void> _onSessionExpired() async {
    final signedIn =
        ref.read(authLocalSourceProvider).getCachedAuthToken() != null;
    if (_handlingExpiry || !signedIn) return;

    _handlingExpiry = true;
    try {
      await ref.read(loginProvider.notifier).signOut();
      appRouter.go(LoginScreen.path);
      _scaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Your session has expired. Please log in again.'),
          ),
        );
    } finally {
      _handlingExpiry = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    // Keeps the organisation's terminology loaded and applied to the translations
    ref.listen(terminologyControllerProvider, (_, _) {});

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '{{project_name.titleCase()}}',
      theme: AppThemeV2.theme(themeMode),
      darkTheme: AppThemeV2.theme(ThemeMode.dark),
      themeMode: themeMode,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      routerConfig: appRouter,
    );
  }
}

