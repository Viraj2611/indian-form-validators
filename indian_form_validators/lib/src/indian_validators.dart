import 'pan_validator.dart';
import 'aadhaar_validator.dart';
import 'mobile_validator.dart';
import 'gst_validator.dart';
import 'ifsc_validator.dart';
import 'pincode_validator.dart';
import 'upi_validator.dart';

/// A single entry-point for all Indian form validators.
///
/// Instead of importing each validator class separately, you can use
/// [IndianValidators] to access all validators from one place.
///
/// Example:
/// ```dart
/// TextFormField(
///   validator: IndianValidators.pan,
/// )
/// ```
class IndianValidators {
  IndianValidators._();

  // ─── Validator functions (use directly as TextFormField validators) ────────

  /// Validates an Indian PAN card number.
  /// See [PanValidator.validate] for details.
  static String? pan(String? value) => PanValidator.validate(value);

  /// Validates an Indian Aadhaar number (with Verhoeff checksum).
  /// See [AadhaarValidator.validate] for details.
  static String? aadhaar(String? value) => AadhaarValidator.validate(value);

  /// Validates an Indian mobile number.
  /// See [MobileValidator.validate] for details.
  static String? mobile(String? value) => MobileValidator.validate(value);

  /// Validates an Indian GST number.
  /// See [GstValidator.validate] for details.
  static String? gst(String? value) => GstValidator.validate(value);

  /// Validates an Indian IFSC code.
  /// See [IfscValidator.validate] for details.
  static String? ifsc(String? value) => IfscValidator.validate(value);

  /// Validates an Indian postal pincode.
  /// See [PincodeValidator.validate] for details.
  static String? pincode(String? value) => PincodeValidator.validate(value);

  /// Validates an Indian UPI Virtual Payment Address (VPA).
  /// See [UpiValidator.validate] for details.
  static String? upi(String? value) => UpiValidator.validate(value);

  // ─── Boolean helpers ───────────────────────────────────────────────────────

  /// Returns `true` if the PAN is valid.
  static bool isValidPan(String? value) => PanValidator.isValid(value);

  /// Returns `true` if the Aadhaar number is valid.
  static bool isValidAadhaar(String? value) => AadhaarValidator.isValid(value);

  /// Returns `true` if the mobile number is valid.
  static bool isValidMobile(String? value) => MobileValidator.isValid(value);

  /// Returns `true` if the GST number is valid.
  static bool isValidGst(String? value) => GstValidator.isValid(value);

  /// Returns `true` if the IFSC code is valid.
  static bool isValidIfsc(String? value) => IfscValidator.isValid(value);

  /// Returns `true` if the pincode is valid.
  static bool isValidPincode(String? value) => PincodeValidator.isValid(value);

  /// Returns `true` if the UPI ID is valid.
  static bool isValidUpi(String? value) => UpiValidator.isValid(value);
}
