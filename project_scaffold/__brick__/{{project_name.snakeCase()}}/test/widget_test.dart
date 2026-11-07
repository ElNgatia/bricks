import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/strings.g.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocale(AppLocale.en);
  });

  test('Translations initialize and return expected strings', () {
    expect(t.common.actions.cancel, equals('Cancel'));
    expect(t.auth.signIn, equals('Sign In'));
  });
}

