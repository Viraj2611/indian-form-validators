/// Validator for Indian Postal PIN codes.
///
/// Format: 6 digits
/// - First digit: postal zone (1–9, no zone starts with 0)
/// - Remaining 5: sub-region and delivery office
///
/// Zone mapping:
/// 1 → Delhi, Haryana, HP, J&K, Punjab, Chandigarh
/// 2 → UP, Uttarakhand
/// 3 → Rajasthan, Gujarat
/// 4 → Maharashtra, MP, Chhattisgarh
/// 5 → AP, Telangana, Karnataka
/// 6 → Tamil Nadu, Kerala
/// 7 → West Bengal, Odisha, NE states
/// 8 → Bihar, Jharkhand, Odisha (overlap)
/// 9 → Army Post Office (APO)
class PincodeValidator {
  PincodeValidator._();

  static final RegExp _pincodeRegex = RegExp(r'^[1-9][0-9]{5}$');

  static const Map<String, String> _zoneMap = {
    '1': 'Delhi / Haryana / Himachal Pradesh / J&K / Punjab / Chandigarh',
    '2': 'Uttar Pradesh / Uttarakhand',
    '3': 'Rajasthan / Gujarat / Daman & Diu / Dadra & Nagar Haveli',
    '4': 'Maharashtra / Madhya Pradesh / Chhattisgarh / Goa',
    '5': 'Andhra Pradesh / Telangana / Karnataka',
    '6': 'Tamil Nadu / Kerala / Puducherry / Lakshadweep',
    '7': 'West Bengal / Odisha / North-East States',
    '8': 'Bihar / Jharkhand',
    '9': 'Army Post Office (APO) / Field Post Office (FPO)',
  };

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: PincodeValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    final pincode = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(pincode)) {
      return 'Pincode must contain digits only';
    }
    if (pincode.length != 6) {
      return 'Pincode must be exactly 6 digits';
    }
    if (!_pincodeRegex.hasMatch(pincode)) {
      return 'Invalid pincode. Cannot start with 0';
    }
    return null;
  }

  /// Returns `true` if the pincode is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Returns the postal zone description for a valid pincode, or `null`.
  static String? getZone(String pincode) {
    if (!isValid(pincode)) return null;
    return _zoneMap[pincode.trim()[0]];
  }
}
