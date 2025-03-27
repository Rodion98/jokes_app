import 'package:injectable/injectable.dart';
import 'package:jokes_app/core/mapper/mapper.dart';
import 'package:jokes_app/features/data/model/joke_model.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';

@lazySingleton
class JokeModelToEntityMapper implements BaseMapper<JokeModel, JokeEntity> {
  @override
  JokeEntity map(JokeModel from) {
    return JokeEntity(
      id: from.id,
      punchline: from.punchline,
      setup: from.setup,
      type: JokeType.fromString(from.type),
    );
  }
}
