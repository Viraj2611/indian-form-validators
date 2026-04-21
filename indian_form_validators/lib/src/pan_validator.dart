/// Validator for Indian PAN (Permanent Account Number) card.
///
/// Format: AAAAA9999A
/// - First 5 characters: uppercase letters
/// - Next 4 characters: digits
/// - Last character: uppercase letter
///
/// The 4th character encodes the taxpayer type:
/// P = Person, C = Company, H = HUF, F = Firm, A = AOP, etc.
class PanValidator {
  PanValidator._();

  static final RegExp _panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  /// Valid PAN taxpayer type codes.
  static const Map<String, String> taxpayerTypes = {
    'P': 'Individual (Person)',
    'C': 'Company',
    'H': 'Hindu Undivided Family (HUF)',
    'F': 'Firm',
    'A': 'Association of Persons (AOP)',
    'T': 'Trust',
    'B': 'Body of Individuals (BOI)',
    'L': 'Local Authority',
    'J': 'Artificial Juridical Person',
    'G': 'Government',
  };

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: PanValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PAN number is required';
    }
    final pan = value.trim().toUpperCase();
    if (pan.length != 10) {
      return 'PAN must be exactly 10 characters';
    }
    if (!_panRegex.hasMatch(pan)) {
      return 'Invalid PAN format. Expected: AAAAA9999A';
    }
    return null;
  }

  /// Returns `true` if the PAN is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Returns the taxpayer type for a valid PAN, or `null` if invalid.
  ///
  /// The 4th character (index 3) of a PAN encodes the entity type.
  static String? getTaxpayerType(String pan) {
    if (!isValid(pan)) return null;
    final code = pan.trim().toUpperCase()[3];
    return taxpayerTypes[code] ?? 'Unknown type ($code)';
  }
}
