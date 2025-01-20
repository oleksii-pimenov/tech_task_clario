class Email {
  final String value;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  const Email._(this.value);

  static Email? create(String input) {
    if (input.isEmpty) return null;
    if (!_emailRegex.hasMatch(input)) return null;
    return Email._(input);
  }

  bool get isValid => _emailRegex.hasMatch(value);
}
