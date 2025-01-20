import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _errorColor = Color(0xFFFF8080);
const _errorFontColor = _errorColor;
const _errorBackgroundColor = Color(0xFFFDEFEE);
const _focusedBorderColor = Color(0xFF151D51);
const _focusedFontColor = Color.fromRGBO(21, 29, 81, 1);
const _focusedBackgroundColor = Colors.white;
const _enabledBorderColor = Color.fromRGBO(21, 29, 81, 0.2);
const _enabledFontColor = Color.fromRGBO(21, 29, 81, 1);
const _enabledBackgroundColor = Colors.white;
const _disabledBorderColor = Color.fromRGBO(21, 29, 81, 0.2);
const _disabledFontColor = Color.fromRGBO(21, 29, 81, 0.2);
const _disabledBackgroundColor = Color.fromRGBO(21, 29, 81, 0.2);
const _successBorderColor = Color.fromRGBO(39, 178, 116, 1);
const _successFontColor = Color.fromRGBO(39, 178, 116, 1);
const _successBackgroundColor = Color(0xFFEFFBF9);

class AppTextFormField extends HookWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isValid;
  final bool enabled;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.isValid = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasBeenValidated = useState(false);

    Color getFillColor() {
      if (!enabled) {
        return _disabledBackgroundColor;
      }
      if (isValid) {
        return _successBackgroundColor;
      }
      if (hasBeenValidated.value && validator?.call(controller.text) != null) {
        return _errorBackgroundColor;
      }
      return _enabledBackgroundColor;
    }

    Color getTextColor() {
      if (!enabled) {
        return _disabledFontColor;
      }
      if (isValid) {
        return _successFontColor;
      }
      if (hasBeenValidated.value && validator?.call(controller.text) != null) {
        return _errorFontColor;
      }
      return _enabledFontColor;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 315),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller,
            enabled: enabled,
            validator: (value) {
              hasBeenValidated.value = true;
              return validator?.call(value);
            },
            style: TextStyle(
              color: getTextColor(),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: getTextColor(),
              ),
              filled: true,
              fillColor: getFillColor(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _enabledBorderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isValid ? _successBorderColor : _enabledBorderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isValid ? _successBorderColor : _focusedBorderColor,
                  width: isValid ? 2 : 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _errorColor,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _disabledBorderColor,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 13.0,
                color: _errorFontColor,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
