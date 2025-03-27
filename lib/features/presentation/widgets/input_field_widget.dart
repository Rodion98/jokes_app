import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jokes_app/core/io_ui.dart';

class InputFieldWidget extends StatefulWidget {
  final int? maxLines;
  final String? title;
  final List<TextInputFormatter>? formatters;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? hintText;
  final VoidCallback? suffixOnTap;
  final String? suffixIcon;
  final Color? suffixIconColor;
  final double paddingLeft;
  final double paddingRight;
  final double? maxWidth;
  final int? maxLenght;
  final FormFieldValidator<String>? validator;
  final bool enableValidation;
  final bool obscureText;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Widget? prefixIcon;

  const InputFieldWidget({
    required this.controller,
    required this.keyboardType,
    super.key,
    this.hintText,
    this.formatters,
    this.title,
    this.suffixOnTap,
    this.suffixIcon,
    this.paddingLeft = 20,
    this.paddingRight = 20,
    this.validator,
    this.enableValidation = false,
    this.maxWidth = double.infinity,
    this.maxLenght,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.suffixIconColor = AppColors.blueMain,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  String? _errorText;
  late bool _isObscured; // Добавляем состояние для скрытия текста

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText; // Инициализируем состояние

    if (widget.enableValidation) {
      widget.controller.addListener(_validateInput);
    }
  }

  @override
  void dispose() {
    if (widget.enableValidation) {
      widget.controller.removeListener(_validateInput);
    }
    super.dispose();
  }

  void _validateInput() {
    final validationError = widget.validator?.call(widget.controller.text);
    setState(() {
      _errorText = validationError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft,
        right: widget.paddingRight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title != null
              ? Text(
                  widget.title ?? '',
                  style: AppTextStyle.headerH3.copyWith(
                    color: const Color(0xFF1D2339).withOpacity(0.72),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.maxWidth!),
            child: TextFormField(
              maxLines: widget.maxLines,
              onFieldSubmitted: widget.onFieldSubmitted,
              onChanged: widget.onChanged,
              buildCounter: (_,
                      {int? currentLength, int? maxLength, bool? isFocused}) =>
                  null,
              maxLength: widget.maxLenght,
              controller: widget.controller,
              validator: (_) => _errorText,
              inputFormatters: widget.formatters,
              keyboardType: widget.keyboardType,
              obscureText: _isObscured,
              style: AppTextStyle.paragraph2.copyWith(
                decoration: TextDecoration.none,
                decorationThickness: 0,
                color: AppColors.black,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.obscureText
                    ? GestureDetector(
                        onTap: _toggleObscureText,
                        child: Icon(
                          _isObscured
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      )
                    : widget.suffixIcon != null
                        ? GestureDetector(
                            onTap: () {
                              // Проверка, чтобы не выполнять действие, если текстовое поле пустое
                              if (widget.controller.text.isNotEmpty) {
                                // Вызовем suffixOnTap, если он предоставлен
                                if (widget.onFieldSubmitted != null) {
                                  widget.onFieldSubmitted
                                      ?.call(widget.controller.text);
                                }
                                // Также можно вызвать onFieldSubmitted, если нужно
                              }
                            },
                            child: SizedBox(),
                          )
                        : null,
                hintText: widget.hintText ?? '',
                hintStyle: AppTextStyle.paragraph2.copyWith(
                  color: AppColors.inputTextGrey,
                ),
                errorText: _errorText,
                disabledBorder: _buildBorder(),
                enabledBorder: _buildBorder(),
                focusedBorder: _buildBorder(),
                border: _buildBorder(),
                fillColor: AppColors.white,
                filled: true,
                contentPadding: const EdgeInsets.only(
                  bottom: 12,
                  left: 20,
                  right: 12,
                  top: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured; // Меняем состояние для скрытия/показа текста
    });
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.borderGrey,
      ),
    );
  }
}
