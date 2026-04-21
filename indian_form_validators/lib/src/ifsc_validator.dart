/// Validator for Indian IFSC (Indian Financial System Code).
///
/// Format: 11 alphanumeric characters
/// - Characters 1–4 : Bank code (uppercase letters)
/// - Character 5    : Always '0' (reserved for future use)
/// - Characters 6–11: Branch code (alphanumeric)
///
/// Example: HDFC0001234, SBIN0005943
class IfscValidator {
  IfscValidator._();

  static final RegExp _ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  /// Common Indian bank codes (non-exhaustive).
  static const Map<String, String> commonBanks = {
    'HDFC': 'HDFC Bank',
    'ICIC': 'ICICI Bank',
    'SBIN': 'State Bank of India',
    'UTIB': 'Axis Bank',
    'KKBK': 'Kotak Mahindra Bank',
    'PUNB': 'Punjab National Bank',
    'BARB': 'Bank of Baroda',
    'CNRB': 'Canara Bank',
    'UBIN': 'Union Bank of India',
    'IOBA': 'Indian Overseas Bank',
    'BKID': 'Bank of India',
    'MAHB': 'Bank of Maharashtra',
    'IDBI': 'IDBI Bank',
    'CBIN': 'Central Bank of India',
    'ALLA': 'Allahabad Bank',
    'ANDB': 'Andhra Bank',
    'CORP': 'Corporation Bank',
    'VIJB': 'Vijaya Bank',
    'FDRL': 'Federal Bank',
    'KARB': 'Karnataka Bank',
    'KVBL': 'Karur Vysya Bank',
    'SIBL': 'South Indian Bank',
    'DCBL': 'DCB Bank',
    'DLXB': 'Dhanlaxmi Bank',
    'INDB': 'IndusInd Bank',
    'YESB': 'Yes Bank',
    'RATN': 'RBL Bank',
    'IDFB': 'IDFC First Bank',
    'PAYTM': 'Paytm Payments Bank',
    'AIRP': 'Airtel Payments Bank',
  };

  /// Returns `null` if valid, or an error message string if invalid.
  ///
  /// Use directly as a Flutter [TextFormField] validator:
  /// ```dart
  /// validator: IfscValidator.validate,
  /// ```
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    final ifsc = value.trim().toUpperCase();
    if (ifsc.length != 11) {
      return 'IFSC code must be exactly 11 characters';
    }
    if (!_ifscRegex.hasMatch(ifsc)) {
      return 'Invalid IFSC format. Expected: ABCD0123456';
    }
    return null;
  }

  /// Returns `true` if the IFSC code is valid, `false` otherwise.
  static bool isValid(String? value) => validate(value) == null;

  /// Returns the bank name for known bank codes, or `null`.
  static String? getBankName(String ifsc) {
    if (!isValid(ifsc)) return null;
    final bankCode = ifsc.trim().toUpperCase().substring(0, 4);
    return commonBanks[bankCode];
  }

  /// Extracts the bank code (first 4 characters) from a valid IFSC.
  static String? getBankCode(String ifsc) {
    if (!isValid(ifsc)) return null;
    return ifsc.trim().toUpperCase().substring(0, 4);
  }

  /// Extracts the branch code (last 6 characters) from a valid IFSC.
  static String? getBranchCode(String ifsc) {
    if (!isValid(ifsc)) return null;
    return ifsc.trim().toUpperCase().substring(5);
  }
}
