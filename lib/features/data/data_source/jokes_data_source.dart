import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jokes_app/features/data/model/joke_model.dart';
import 'package:retrofit/retrofit.dart';

part 'jokes_data_source.g.dart';

@RestApi()
@singleton
abstract class JokesDataSource {
  @factoryMethod
  factory JokesDataSource(Dio dio) = _JokesDataSource;
  @GET('/random_ten')
  Future<HttpResponse<List<JokeModel>>> fetchJokes();

  @GET('/jokes/{type}/ten')
  Future<HttpResponse<List<JokeModel>>> fetchJokesByType(
    @Path('type') String type,
  );
}
