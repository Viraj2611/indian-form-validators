/// Validator for Indian GST (Goods and Services Tax) Number.
///
/// Format: 15 alphanumeric characters
/// - Characters 1–2  : State code (01–38)
/// - Characters 3–12 : PAN of the entity
/// - Character 13    : Entity number (1–9 or A–Z)
/// - Character 14    : 'Z' by default
/// - Character 15    : Checksum digit
///
/// Example: 27AAPFU0939F1ZV
class GstValidator {
  GstValidator._();

  static final RegExp _gstRegex = RegExp(
    r'^[0-3][0-9][A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );

  /// Valid Indian state/UT codes (01–38).
  static const Map<String, String> stateCodes = {
    '01': 'Jammu & Kashmir',
    '02': 'Himachal Pradesh',
    '03': 'Punjab',
    '04': 'Chandigarh',
    '05': 'Uttarakhand',
    '06': 'Haryana',
    '07': 'Delhi',
    '08': 'Rajasthan',
    '09': 'Uttar Pradesh',
    '10': 'Bihar',
    '11': 'Sikkim',
    '12': 'Arunachal Pradesh',
    '13': 'Nagaland',
    '14': 'Manipur',
    '15': 'Mizoram',
    '16': 'Tripura',
    '17': 'Meghalaya',
    '18': 'Assam',
    '19': 'West Bengal',
    '20': 'Jharkhand',
    '21': 'Odisha',
    '22': 'Chhattisgarh',
    '23': 'Madhya Pradesh',
    '24': 'Gujarat',
    '26': 'Dadra and Nagar Haveli and Daman and Diu',
    '27': 'Maharashtra',
    '28': 'Andhra Pradesh (old)',
    '29': 'Karnataka',
    '30': 'Goa',
    '31': 'Lakshadweep',
    '32': 'Kerala',
    '33': 'Tamil Nadu',
    '34': 'Puducherry',
    '35': 'Andaman and Nicobar Islands',
    '36': 'Telangana',
    '37': 'Andhra Pradesh',
    '38': 'Ladakh',
    '97': 'Other Territory',
    '99': 'Centre Jurisdiction',
  };

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: GstValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GST number is required';
    }
    final gst = value.trim().toUpperCase();
    if (gst.length != 15) {
      return 'GST number must be exactly 15 characters';
    }
    if (!_gstRegex.hasMatch(gst)) {
      return 'Invalid GST format. Expected: 27AAPFU0939F1ZV';
    }
    final stateCode = gst.substring(0, 2);
    if (!stateCodes.containsKey(stateCode)) {
      return 'Invalid state code: $stateCode';
    }
    return null;
  }

  /// Returns `true` if the GST number is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Returns the state name from a valid GST number, or `null` if invalid.
  static String? getState(String gst) {
    if (!isValid(gst)) return null;
    return stateCodes[gst.trim().toUpperCase().substring(0, 2)];
  }

  /// Extracts the embedded PAN from a valid GST number, or `null` if invalid.
  static String? extractPan(String gst) {
    if (!isValid(gst)) return null;
    return gst.trim().toUpperCase().substring(2, 12);
  }
}
