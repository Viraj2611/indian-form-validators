/// Validator for Indian mobile numbers.
///
/// Rules:
/// - Must be exactly 10 digits
/// - Must start with 6, 7, 8, or 9 (TRAI allocation)
/// - Optional +91 or 0 prefix is handled automatically
class MobileValidator {
  MobileValidator._();

  static final RegExp _mobileRegex = RegExp(r'^[6-9]\d{9}$');

  /// Strips common Indian prefixes: +91, 91, 0
  static String _normalize(String value) {
    String mobile = value.replaceAll(RegExp(r'\s|-'), '');
    if (mobile.startsWith('+91')) {
      mobile = mobile.substring(3);
    } else if (mobile.startsWith('91') && mobile.length == 12) {
      mobile = mobile.substring(2);
    } else if (mobile.startsWith('0') && mobile.length == 11) {
      mobile = mobile.substring(1);
    }
    return mobile;
  }

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Accepts formats: `9876543210`, `+919876543210`, `09876543210`
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: MobileValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final mobile = _normalize(value.trim());
    if (!RegExp(r'^\d+$').hasMatch(mobile)) {
      return 'Mobile number must contain digits only';
    }
    if (mobile.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!_mobileRegex.hasMatch(mobile)) {
      return 'Invalid mobile number. Must start with 6, 7, 8, or 9';
    }
    return null;
  }

  /// Returns `true` if the mobile number is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Returns the normalized 10-digit number, or `null` if invalid.
  static String? normalize(String value) {
    final mobile = _normalize(value.trim());
    return isValid(mobile) ? mobile : null;
  }
}
