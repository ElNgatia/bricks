import 'package:{{project_name.snakeCase()}}/app/i18n/term.dart';

/// Where each API term lives in the translation files. The default wording is
/// in each feature's `i18n/<feature>_en.i18n.json`, under `terms`.
const terminologyPaths = {
  'user': 'common.terms.user',
  'organization': 'common.terms.organization',
  'unit': 'common.terms.unit',
  'item': 'common.terms.item',
};

/// The organisation's custom wording: the terms it has renamed.
///
/// Read from and cached as `{"version": "...", "terms": {"<key>": Term}}`.
class Terminology {
  const Terminology({this.version = '', this.terms = const {}});

  /// Hash/version that changes whenever any term changes.
  final String version;
  final Map<String, Term> terms;

  /// Default baseline terminology.
  static const standard = Terminology();

  factory Terminology.fromJson(Map<String, dynamic> json) {
    final terms = <String, Term>{};
    final raw = json['terms'];
    if (raw is Map) {
      for (final entry in raw.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          terms[entry.key.toString()] = Term.fromJson(value);
        }
      }
    }
    return Terminology(version: json['version']?.toString() ?? '', terms: terms);
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'terms': {for (final e in terms.entries) e.key: e.value.toJson()},
  };

  /// The organisation's wording as slang translation overrides, keyed by
  /// translation path. Anything not set keeps its bundled default.
  Map<String, String> toOverrides() {
    final overrides = <String, String>{};
    for (final entry in terms.entries) {
      final path = terminologyPaths[entry.key];
      if (path == null) continue;
      final term = entry.value;
      overrides['$path.singular'] = term.singular;
      overrides['$path.plural'] = term.plural ?? term.singular;
      for (final form in term.forms.entries) {
        overrides['$path.${form.key}'] = form.value;
      }
    }
    return overrides;
  }

  @override
  bool operator ==(Object other) =>
      other is Terminology && other.version == version;

  @override
  int get hashCode => version.hashCode;
}
