import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:jokes_app/core/error/exception_handler.dart';
import 'package:jokes_app/core/error/failure.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';
import 'package:jokes_app/features/domain/use_case/fetch_jokes_by_type_use_case.dart';
import 'package:jokes_app/features/domain/use_case/fetch_jokes_use_case.dart';

part 'jokes_state.dart';

class JokesCubit extends Cubit<JokesState> {
  final FetchJokesUseCase _fetchAllJokesUseCase;
  final FetchJokesByTypeUseCase _fetchByTypeUseCase;
  JokeType _currentFilter = JokeType.all;
  String _searchQuery = '';
  List<JokeEntity> _currentJokes = [];
  final Set<int> _favoriteIds = {};
  final List<JokeEntity> _allFavorites = [];

  JokesCubit(
    this._fetchAllJokesUseCase,
    this._fetchByTypeUseCase,
  ) : super(JokesInitial());

  JokeType get currentFilter => _currentFilter;

  void toggleFavorite(JokeEntity joke) {
    if (_favoriteIds.contains(joke.id)) {
      _favoriteIds.remove(joke.id);
      _allFavorites.removeWhere((j) => j.id == joke.id);
    } else {
      _favoriteIds.add(joke.id);
      _allFavorites.add(joke);
    }
    _applyFilters();
  }

  bool isFavorite(int jokeId) => _favoriteIds.contains(jokeId);

  Future<void> fetchJokes({JokeType? filter}) async {
    _currentFilter = filter ?? JokeType.all;

    if (_currentFilter == JokeType.favorites) {
      _applyFilters();
      return;
    }

    emit(JokesLoading());

    try {
      final result = _currentFilter == JokeType.all
          ? await _fetchAllJokesUseCase(null)
          : await _fetchByTypeUseCase(_currentFilter.apiValue);

      result.fold(
        (failure) => emit(JokesError(failure: failure)),
        (jokes) {
          _currentJokes = jokes;
          _updateFavoritesInCurrentList();
          _applyFilters();
        },
      );
    } catch (e) {
      emit(JokesError(failure: ErrorHandler.handle(e)));
    }
  }

  void _updateFavoritesInCurrentList() {
    for (final joke in _currentJokes) {
      if (_favoriteIds.contains(joke.id)) {
        joke.isFavorite = true;
      }
    }
  }

  void searchJokes(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    List<JokeEntity> filteredJokes = [];

    if (_currentFilter == JokeType.favorites) {
      filteredJokes = List.from(_allFavorites);
    } else {
      filteredJokes = List.from(_currentJokes);
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredJokes = filteredJokes
          .where((joke) =>
              joke.setup.toLowerCase().contains(query) ||
              joke.punchline.toLowerCase().contains(query))
          .toList();
    }

    emit(JokesLoaded(jokes: filteredJokes));
  }

  Future<void> copyJokesToClipboard(List<JokeEntity> jokes) async {
    if (jokes.isEmpty) {
      throw Exception("No jokes to copy");
    }

    final buffer = StringBuffer();

    for (final joke in jokes) {
      buffer.writeln(
          "- [${joke.type.displayName}] ${joke.setup} → ${joke.punchline}");
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
  }
}
