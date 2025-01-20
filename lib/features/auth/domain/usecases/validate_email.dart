// Project imports:
import '../value_objects/email.dart';

class ValidateEmail {
  String? call(String email) {
    final emailObject = Email.create(email);
    if (emailObject == null) {
      if (email.isEmpty) return 'Email is required';
      return 'Invalid email format';
    }
    return null;
  }
}
