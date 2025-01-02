import 'package:json_annotation/json_annotation.dart';

part '{{name}}_entity.g.dart';


@JsonSerializable()
class {{name.pascalCase()}}Entity{
  factory {{name.pascalCase()}}Entity.fromJson(Map<String, dynamic> json) => _${{name.pascalCase()}}EntityFromJson(json);

  Map<String, dynamic> toJson() => _${{name.pascalCase()}}EntityToJson(this);
}