import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';
import 'package:{{project_name.snakeCase()}}/hive/hive_adapters.dart';

class HiveManager {
  HiveManager._();

  static final HiveManager instance = HiveManager._();

  late Box<Auth> userBox;
  late Box settingsBox;
  late Box<String> terminologyBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();

    await _initEncryptedBoxes();
    await _openBoxes();
  }

  void _registerAdapters() {
    Hive.registerAdapter(AuthAdapter());
  }

  Future<void> _openBoxes() async {
    settingsBox = await Hive.openBox('settingsBox');
    terminologyBox = await Hive.openBox<String>('terminologyBox');
  }

  Future<void> _initEncryptedBoxes() async {
    const secureStorage = FlutterSecureStorage();

    final encryptionKeyString = await secureStorage.read(key: 'key');
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    }
    final key = await secureStorage.read(key: 'key');
    final encryptionKeyUint8List = base64Url.decode(key!);

    userBox = await Hive.openBox<Auth>(
      'authBox',
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }
}

