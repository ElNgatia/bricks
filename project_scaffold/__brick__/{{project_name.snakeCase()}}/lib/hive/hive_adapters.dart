import 'package:hive_ce/hive_ce.dart';
import 'package:{{project_name.snakeCase()}}/features/auth/data/models/auth.dart';

class AuthAdapter extends TypeAdapter<Auth> {
  @override
  final int typeId = 0;

  @override
  Auth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Auth(
      token: fields[0] as String? ?? '',
      tokenType: fields[1] as String? ?? 'Bearer',
      userId: fields[2] as String? ?? '',
      name: fields[3] as String? ?? '',
      email: fields[4] as String? ?? '',
      defaultOrganisationCode: fields[5] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, Auth obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.tokenType)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.defaultOrganisationCode);
  }
}

