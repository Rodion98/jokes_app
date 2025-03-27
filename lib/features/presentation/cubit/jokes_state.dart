part of 'jokes_cubit.dart';

sealed class JokesState extends Equatable {
  const JokesState();
}

final class JokesInitial extends JokesState {
  @override
  List<Object> get props => [];
}

final class JokesLoading extends JokesState {
  @override
  List<Object?> get props => [];
}

final class JokesLoaded extends JokesState {
  final List<JokeEntity> jokes;
  const JokesLoaded({required this.jokes});

  @override
  List<Object?> get props => [jokes];
}

final class JokesError extends JokesState {
  final Failure failure;
  const JokesError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
