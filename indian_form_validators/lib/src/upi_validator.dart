/// Validator for Indian UPI Virtual Payment Address (VPA).
///
/// Format: `username@bankhandle`
/// - Username: alphanumeric, dots, hyphens, underscores (3–256 chars)
/// - @ separator
/// - Bank handle: lowercase letters only (2–64 chars)
///
/// Examples: viraj@okicici, 9876543210@paytm, name.surname@ybl
///
/// Common bank handles: okicici, oksbi, okaxis, paytm, ybl, upi, ibl,
/// axl, okhdfcbank, apl, etc.
class UpiValidator {
  UpiValidator._();

  static final RegExp _upiRegex = RegExp(
    r'^[a-zA-Z0-9.\-_]{3,256}@[a-zA-Z]{2,64}$',
  );

  /// Common UPI handles in India (non-exhaustive).
  static const List<String> commonHandles = [
    'okicici',
    'oksbi',
    'okaxis',
    'okhdfcbank',
    'paytm',
    'ybl',
    'upi',
    'ibl',
    'axl',
    'apl',
    'waicici',
    'wahdfcbank',
    'yapl',
    'barodampay',
    'cnrb',
    'kbl',
    'sib',
    'federal',
    'freecharge',
    'ikwik',
    'timecosmos',
    'pingpay',
  ];

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: UpiValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'UPI ID is required';
    }
    final upi = value.trim().toLowerCase();
    if (!upi.contains('@')) {
      return 'UPI ID must contain @';
    }
    if (upi.split('@').length != 2) {
      return 'UPI ID must have exactly one @';
    }
    if (!_upiRegex.hasMatch(upi)) {
      return 'Invalid UPI ID format. Expected: username@bankhandle';
    }
    return null;
  }

  /// Returns `true` if the UPI ID is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Extracts the username part before `@`, or `null` if invalid.
  static String? getUsername(String upi) {
    if (!isValid(upi)) return null;
    return upi.trim().split('@')[0];
  }

  /// Extracts the bank handle part after `@`, or `null` if invalid.
  static String? getHandle(String upi) {
    if (!isValid(upi)) return null;
    return upi.trim().split('@')[1].toLowerCase();
  }

  /// Returns `true` if the handle is one of the well-known Indian bank handles.
  static bool isKnownHandle(String upi) {
    final handle = getHandle(upi);
    if (handle == null) return false;
    return commonHandles.contains(handle);
  }
}
