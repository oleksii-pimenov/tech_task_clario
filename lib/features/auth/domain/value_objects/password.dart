class Password {
  final String value;

  const Password._(this.value);

  static Password? create(String input) {
    if (input.isEmpty) return null;
    if (input.length < 6) return null;
    if (input.length > 64) return null;
    if (!input.contains(RegExp(r'[A-Z]'))) return null;
    if (!input.contains(RegExp(r'[0-9]'))) return null;
    return Password._(input);
  }

  bool get isMinLengthValid => value.length >= 6;
  bool get isMaxLengthValid => value.length <= 64;
  bool get hasUppercase => value.contains(RegExp(r'[A-Z]'));
  bool get hasDigit => value.contains(RegExp(r'[0-9]'));
}
