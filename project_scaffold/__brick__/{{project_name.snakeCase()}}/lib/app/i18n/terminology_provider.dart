import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/strings.g.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology_local_source.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/terminology_remote_source.dart';

final currentOrgCodeProvider = StateProvider<String?>((ref) => null);

final terminologyControllerProvider =
    NotifierProvider<TerminologyController, Terminology>(() {
  return TerminologyController();
});

class TerminologyController extends Notifier<Terminology> {
  static const refreshInterval = Duration(minutes: 15);

  String? _orgCode;
  DateTime? _lastRefresh;

  @override
  Terminology build() {
    final code = ref.watch(currentOrgCodeProvider);
    _orgCode = code;
    _lastRefresh = null;

    final terminology = code == null
        ? Terminology.standard
        : ref.read(terminologyLocalSourceProvider).read(code) ??
            Terminology.standard;

    Future.microtask(() {
      _apply(state);
      if (code != null) refresh(force: true);
    });

    return terminology;
  }

  void _apply(Terminology terminology) {
    LocaleSettings.overrideTranslationsFromMapSync(
      locale: LocaleSettings.currentLocale,
      isFlatMap: true,
      map: terminology.toOverrides(),
    );
  }

  Future<void> refresh({bool force = false}) async {
    final code = _orgCode;
    if (code == null) return;
    final last = _lastRefresh;
    if (!force &&
        last != null &&
        DateTime.now().difference(last) < refreshInterval) {
      return;
    }
    _lastRefresh = DateTime.now();

    try {
      final fresh = await ref.read(terminologyRemoteSourceProvider).fetch(code);
      if (code != _orgCode) return;
      await ref.read(terminologyLocalSourceProvider).save(code, fresh);
      if (fresh == state) return;
      state = fresh;
      _apply(fresh);
    } catch (_) {
      if (code == _orgCode) _lastRefresh = null;
    }
  }
}

