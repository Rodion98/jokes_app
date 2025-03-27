import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jokes_app/core/di/inject.dart';
import 'package:jokes_app/features/domain/use_case/fetch_jokes_by_type_use_case.dart';
import 'package:jokes_app/features/domain/use_case/fetch_jokes_use_case.dart';
import 'package:jokes_app/features/presentation/cubit/jokes_cubit.dart';
import 'package:jokes_app/features/presentation/screens/jokes_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JokesCubit(
        inject<FetchJokesUseCase>(),
        inject<FetchJokesByTypeUseCase>(),
      ),
      child: const MaterialApp(
        home: JokesScreen(),
      ),
    );
  }
}
