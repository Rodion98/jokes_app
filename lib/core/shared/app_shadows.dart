part of '../io_ui.dart';

class AppShadows {
  static BoxShadow containerShadow = BoxShadow(
    color: AppColors.black.withOpacity(0.26), // Цвет тени
    offset: Offset(0, 4), // Смещение тени (по X и Y)
    blurRadius: 10, // Радиус размытия
    spreadRadius: 2, // Радиус распространения
  );
}
