/// One organisation-defined label from the terminology endpoint, e.g.
/// "Client" in place of the default "Customer".
class Term {
  const Term({required this.singular, this.plural, this.forms = const {}});

  /// Always present, title-cased for buttons and titles.
  final String singular;

  /// Null when the term has no plural; the singular is then used unchanged.
  final String? plural;

  /// Sentence forms such as `past`, `noun` and `progressive`.
  final Map<String, String> forms;

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      singular: json['singular'].toString(),
      plural: _nonEmpty(json['plural']),
      forms: parseForms(json['forms']),
    );
  }

  Map<String, dynamic> toJson() => {
    'singular': singular,
    'plural': plural,
    'forms': forms,
  };

  static Map<String, String> parseForms(Object? raw) {
    if (raw is! Map) return const {};
    return {
      for (final entry in raw.entries)
        if (_nonEmpty(entry.value) != null)
          entry.key.toString(): entry.value.toString(),
    };
  }

  static String? _nonEmpty(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}

