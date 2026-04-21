/// Validator for Indian Aadhaar Number.
///
/// Format: 12 digits
/// - First digit cannot be 0 or 1 (UIDAI rule)
/// - Validated using the Verhoeff checksum algorithm
///
/// Reference: https://en.wikipedia.org/wiki/Verhoeff_algorithm
class AadhaarValidator {
  AadhaarValidator._();

  // Verhoeff multiplication table
  static const List<List<int>> _d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  ];

  // Verhoeff permutation table
  static const List<List<int>> _p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
  ];

  /// Verifies a number string using the Verhoeff algorithm.
  static bool _verhoeffCheck(String number) {
    int c = 0;
    final digits = number.split('').reversed.toList();
    for (int i = 0; i < digits.length; i++) {
      final digit = int.tryParse(digits[i]);
      if (digit == null) return false;
      c = _d[c][_p[i % 8][digit]];
    }
    return c == 0;
  }

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: AadhaarValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Aadhaar number is required';
    }
    // Strip spaces (Aadhaar is often written as XXXX XXXX XXXX)
    final aadhaar = value.replaceAll(RegExp(r'\s'), '');

    if (!RegExp(r'^\d+$').hasMatch(aadhaar)) {
      return 'Aadhaar must contain digits only';
    }
    if (aadhaar.length != 12) {
      return 'Aadhaar must be exactly 12 digits';
    }
    if (aadhaar[0] == '0' || aadhaar[0] == '1') {
      return 'Aadhaar cannot start with 0 or 1';
    }
    if (!_verhoeffCheck(aadhaar)) {
      return 'Invalid Aadhaar number (checksum failed)';
    }
    return null;
  }

  /// Returns `true` if the Aadhaar number is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Formats a raw 12-digit Aadhaar string as `XXXX XXXX XXXX`.
  ///
  /// Returns `null` if the input is invalid.
  static String? format(String value) {
    final aadhaar = value.replaceAll(RegExp(r'\s'), '');
    if (aadhaar.length != 12) return null;
    return '${aadhaar.substring(0, 4)} ${aadhaar.substring(4, 8)} ${aadhaar.substring(8)}';
  }

  /// Masks an Aadhaar number as `XXXX XXXX 1234` (last 4 digits visible).
  ///
  /// Returns `null` if the input is invalid.
  static String? mask(String value) {
    final aadhaar = value.replaceAll(RegExp(r'\s'), '');
    if (aadhaar.length != 12) return null;
    return 'XXXX XXXX ${aadhaar.substring(8)}';
  }
}
