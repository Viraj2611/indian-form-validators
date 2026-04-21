// ignore_for_file: avoid_print

import 'package:indian_form_validators/indian_form_validators.dart';

void main() {
  // ── PAN ──────────────────────────────────────────────────────────────────
  print('=== PAN ===');
  print(PanValidator.validate('ABCDE1234F')); // null (valid)
  print(PanValidator.validate('INVALID')); // error string
  print(PanValidator.getTaxpayerType('AABCP1234D')); // Individual (Person)

  // ── Aadhaar ───────────────────────────────────────────────────────────────
  print('\n=== Aadhaar ===');
  const aadhaar = '499118665246';
  print(AadhaarValidator.validate(aadhaar)); // null (valid)
  print(AadhaarValidator.format(aadhaar)); // 4991 1866 5246
  print(AadhaarValidator.mask(aadhaar)); // XXXX XXXX 5246

  // ── Mobile ────────────────────────────────────────────────────────────────
  print('\n=== Mobile ===');
  print(MobileValidator.validate('9876543210')); // null
  print(MobileValidator.validate('+919876543210')); // null
  print(MobileValidator.normalize('+919876543210')); // 9876543210

  // ── GST ───────────────────────────────────────────────────────────────────
  print('\n=== GST ===');
  const gst = '27AAPFU0939F1ZV';
  print(GstValidator.validate(gst)); // null
  print(GstValidator.getState(gst)); // Maharashtra
  print(GstValidator.extractPan(gst)); // AAPFU0939F

  // ── IFSC ──────────────────────────────────────────────────────────────────
  print('\n=== IFSC ===');
  const ifsc = 'HDFC0001234';
  print(IfscValidator.validate(ifsc)); // null
  print(IfscValidator.getBankName(ifsc)); // HDFC Bank
  print(IfscValidator.getBranchCode(ifsc)); // 001234

  // ── Pincode ───────────────────────────────────────────────────────────────
  print('\n=== Pincode ===');
  print(PincodeValidator.validate('400001')); // null (Mumbai)
  print(PincodeValidator.getZone('400001')); // Maharashtra zone

  // ── UPI ───────────────────────────────────────────────────────────────────
  print('\n=== UPI ===');
  print(UpiValidator.validate('viraj@okicici')); // null
  print(UpiValidator.getHandle('viraj@okicici')); // okicici
  print(UpiValidator.isKnownHandle('viraj@paytm')); // true

  // ── Facade ────────────────────────────────────────────────────────────────
  print('\n=== IndianValidators (facade) ===');
  print(IndianValidators.pan('ABCDE1234F')); // null
  print(IndianValidators.mobile('9876543210')); // null
  print(IndianValidators.isValidIfsc('HDFC0001234')); // true
}
