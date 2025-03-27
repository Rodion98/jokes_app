import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jokes_app/core/shared/app_spacing.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';
import 'package:jokes_app/features/presentation/cubit/jokes_cubit.dart';
import 'package:jokes_app/features/presentation/widgets/input_field_widget.dart';
import 'package:jokes_app/features/presentation/widgets/jokes_container.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final JokeType _currentFilter = JokeType.all;
  Timer? _searchDebounce;
  final ScrollController _scrollController = ScrollController();
  List<JokeEntity> _visibleJokes = [];

  @override
  void initState() {
    super.initState();
    context.read<JokesCubit>().fetchJokes();
    _scrollController.addListener(_updateVisibleJokes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateVisibleJokes() {
    final cubit = context.read<JokesCubit>();
    if (cubit.state is! JokesLoaded) return;

    final loadedState = cubit.state as JokesLoaded;
    final firstVisible =
        _scrollController.position.pixels ~/ 100; // Примерная высота элемента
    final lastVisible = firstVisible + 6;

    setState(() {
      _visibleJokes = loadedState.jokes
          .skip(firstVisible)
          .take(lastVisible - firstVisible + 1)
          .toList();
    });
  }

  Future<void> _copyVisibleJokes() async {
    if (_visibleJokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет видимых шуток для копирования')),
      );
      return;
    }

    try {
      final text = _visibleJokes
          .map((joke) =>
              "- [${joke.type.displayName}] ${joke.setup} → ${joke.punchline}")
          .join("\n");

      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Видимые шутки скопированы')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }

  void _onFilterSelected(JokeType type) {
    context.read<JokesCubit>().fetchJokes(filter: type);
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<JokesCubit>().searchJokes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.medium,
            vertical: Insets.medium,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy jokes to clipboard',
                    onPressed: _copyVisibleJokes,
                  ),
                  Expanded(
                    child: InputFieldWidget(
                      paddingLeft: 0,
                      paddingRight: 0,
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      hintText: 'Search jokes...',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  PopupMenuButton<JokeType>(
                    icon: const Icon(Icons.filter_alt, size: 28),
                    onSelected: _onFilterSelected,
                    itemBuilder: (context) => JokeType.values.map((type) {
                      return PopupMenuItem<JokeType>(
                        value: type,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: type.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(type.displayName),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildActiveFilterChip(),
              const SizedBox(height: 10),
              _buildJokesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _currentFilter == JokeType.all
          ? const SizedBox.shrink()
          : Chip(
              key: ValueKey(_currentFilter),
              label: Text(
                _currentFilter.displayName,
                style: TextStyle(color: _currentFilter.color),
              ),
              backgroundColor: _currentFilter.color.withOpacity(0.2),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _onFilterSelected(JokeType.all),
            ),
    );
  }

  Widget _buildJokesList() {
    return Expanded(
      child: BlocConsumer<JokesCubit, JokesState>(
        listener: (context, state) {
          if (state is JokesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is JokesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JokesLoaded) {
            final jokes = state.jokes;
            if (jokes.isEmpty) {
              return Center(
                child: Text(
                  _currentFilter == JokeType.favorites
                      ? 'No favorite jokes yet'
                      : 'No jokes found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              itemCount: jokes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final joke = jokes[index];
                final isFavorite =
                    context.read<JokesCubit>().isFavorite(joke.id);
                return JokesContainer(
                  joke: joke,
                  isFavorite: isFavorite,
                  onToggleFavorite: () {
                    context.read<JokesCubit>().toggleFavorite(joke);
                    _showFavoriteSnackbar(context, isFavorite);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showFavoriteSnackbar(BuildContext context, bool wasFavorite) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(wasFavorite ? 'Removed from favorites' : 'Added to favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
