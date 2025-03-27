import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:jokes_app/core/di/di_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
Future<GetIt> initDi() async => getIt.init();
