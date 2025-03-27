import 'package:json_annotation/json_annotation.dart';

part 'joke_model.g.dart';

@JsonSerializable()
class JokeModel {
  final String type;
  final String setup;
  final String punchline;
  final int id;

  JokeModel(
      {required this.type,
      required this.setup,
      required this.punchline,
      required this.id});

  factory JokeModel.fromJson(Map<String, dynamic> json) =>
      _$JokeModelFromJson(json);

  Map<String, dynamic> toJson() => _$JokeModelToJson(this);
}
