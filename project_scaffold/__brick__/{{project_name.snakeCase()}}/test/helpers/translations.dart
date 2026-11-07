import 'package:flutter/widgets.dart';
import 'package:{{project_name.snakeCase()}}/app/i18n/strings.g.dart';

Widget withTranslations(Widget app) => TranslationProvider(child: app);

