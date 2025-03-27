import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:jokes_app/core/io_ui.dart';

class JokeEntity extends Equatable {
  final JokeType type;
  final String setup;
  final String punchline;
  final int id;
  bool isFavorite;

  JokeEntity({
    required this.type,
    required this.setup,
    required this.punchline,
    required this.id,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [type, setup, punchline, id];
}

enum JokeType {
  all(AppColors.blueMain),
  general(AppColors.liteYellow),
  knockKnock(AppColors.orange),
  programming(AppColors.liteOrange),
  dad(AppColors.yellow),
  favorites(AppColors.black);

  final Color color;
  const JokeType(this.color);

  String get apiValue {
    switch (this) {
      case JokeType.knockKnock:
        return 'knock-knock';
      case JokeType.favorites:
        return '';
      case JokeType.all:
        return '';
      default:
        return name.toLowerCase();
    }
  }

  String get displayName {
    switch (this) {
      case JokeType.all:
        return 'All Jokes';
      case JokeType.knockKnock:
        return 'Knock-Knock';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  static JokeType fromString(String typeString) {
    final normalized = typeString.toLowerCase().trim();

    switch (normalized) {
      case 'all':
      case '':
        return JokeType.all;
      case 'general':
        return JokeType.general;
      case 'knock-knock':
      case 'knockknock':
        return JokeType.knockKnock;
      case 'programming':
        return JokeType.programming;
      case 'dad':
      case 'dadjoke':
        return JokeType.dad;
      default:
        throw ArgumentError('Unknown joke type: $typeString');
    }
  }

  static bool isSupportedType(String typeString) {
    try {
      fromString(typeString);
      return true;
    } catch (_) {
      return false;
    }
  }
}
