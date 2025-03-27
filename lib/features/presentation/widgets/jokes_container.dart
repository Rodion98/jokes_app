import 'package:flutter/material.dart';
import 'package:jokes_app/core/shared/app_spacing.dart';
import 'package:jokes_app/features/domain/entity/joke_entity.dart';

class JokesContainer extends StatefulWidget {
  final JokeEntity joke;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const JokesContainer(
      {super.key,
      required this.joke,
      required this.isFavorite,
      required this.onToggleFavorite});

  @override
  State<JokesContainer> createState() => _JokesContainerState();
}

class _JokesContainerState extends State<JokesContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String length =
        (widget.joke.setup.length + widget.joke.punchline.length).toString();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.xxsmall,
        vertical: Insets.small,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.joke.type.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: widget.onToggleFavorite,
                  ),
                  Expanded(
                    child: Text(
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      widget.joke.setup,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Gap.xsmall(),
                  Column(
                    children: [
                      Text(
                        length,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                      )
                    ],
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 8),
                Text(
                  widget.joke.punchline,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
