# indian_form_validators

[![pub version](https://img.shields.io/pub/v/indian_form_validators.svg)](https://pub.dev/packages/indian_form_validators)
[![pub points](https://img.shields.io/pub/points/indian_form_validators)](https://pub.dev/packages/indian_form_validators/score)
[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue)](LICENSE)

A comprehensive, **zero-dependency** Dart package for validating Indian financial and identity form fields.

Works as drop-in validators for Flutter `TextFormField` widgets.

---

## Features

| Field | Validator | Extras |
|---|---|---|
| PAN Card | ✅ Format validation | Taxpayer type lookup |
| Aadhaar Number | ✅ Verhoeff checksum | Format / Mask utilities |
| Mobile Number | ✅ TRAI digit rules | Prefix normalization (+91, 0) |
| GST Number | ✅ Format + state code | State lookup / PAN extraction |
| IFSC Code | ✅ Format validation | Bank name / branch code |
| Pincode | ✅ 6-digit zone rules | Postal zone lookup |
| UPI / VPA | ✅ VPA format | Handle recognition |

---

## Installation

```yaml
dependencies:
  indian_form_validators: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Usage

### Option 1 — Single import (recommended)

```dart
import 'package:indian_form_validators/indian_form_validators.dart';

TextFormField(
  decoration: InputDecoration(labelText: 'PAN Number'),
  validator: IndianValidators.pan,
)

TextFormField(
  decoration: InputDecoration(labelText: 'Aadhaar Number'),
  validator: IndianValidators.aadhaar,
)

TextFormField(
  decoration: InputDecoration(labelText: 'Mobile Number'),
  validator: IndianValidators.mobile,
)
```

### Option 2 — Individual classes

```dart
import 'package:indian_form_validators/indian_form_validators.dart';

// Returns null if valid, error string if invalid
final error = PanValidator.validate('ABCDE1234F'); // null

// Boolean check
final isValid = PanValidator.isValid('ABCDE1234F'); // true

// Utility
final type = PanValidator.getTaxpayerType('AABCP1234D'); // "Individual (Person)"
```

---

## Validators in Detail

### PAN Card

```dart
PanValidator.validate('ABCDE1234F');        // null ✅
PanValidator.validate('abcde1234f');        // null ✅ (normalized)
PanValidator.validate('INVALID');           // "Invalid PAN format..."

PanValidator.getTaxpayerType('AABCP1234D'); // "Individual (Person)"
PanValidator.getTaxpayerType('AABCC1234D'); // "Company"
```

**Format:** `AAAAA9999A` — 5 letters, 4 digits, 1 letter

---

### Aadhaar Number

```dart
AadhaarValidator.validate('499118665246');        // null ✅
AadhaarValidator.validate('4991 1866 5246');      // null ✅ (spaces stripped)
AadhaarValidator.validate('012345678901');        // "Aadhaar cannot start with 0 or 1"
AadhaarValidator.validate('499118665247');        // "Invalid Aadhaar (checksum failed)"

AadhaarValidator.format('499118665246');  // "4991 1866 5246"
AadhaarValidator.mask('499118665246');    // "XXXX XXXX 5246"
```

Uses the **Verhoeff algorithm** for checksum validation — the same algorithm UIDAI uses.

---

### Indian Mobile Number

```dart
MobileValidator.validate('9876543210');      // null ✅
MobileValidator.validate('+919876543210');   // null ✅
MobileValidator.validate('09876543210');     // null ✅
MobileValidator.validate('5876543210');      // "Must start with 6, 7, 8, or 9"

MobileValidator.normalize('+919876543210'); // "9876543210"
```

---

### GST Number

```dart
GstValidator.validate('27AAPFU0939F1ZV'); // null ✅
GstValidator.getState('27AAPFU0939F1ZV'); // "Maharashtra"
GstValidator.extractPan('27AAPFU0939F1ZV'); // "AAPFU0939F"
```

**Format:** `SS AAAAA 9999 A E Z C` — 2-digit state code + PAN + entity + Z + checksum

---

### IFSC Code

```dart
IfscValidator.validate('HDFC0001234');    // null ✅
IfscValidator.getBankName('HDFC0001234'); // "HDFC Bank"
IfscValidator.getBranchCode('HDFC0001234'); // "001234"
```

**Format:** `ABCD0123456` — 4-letter bank code, `0`, 6-char branch code

---

### Pincode

```dart
PincodeValidator.validate('400001');    // null ✅ (Mumbai)
PincodeValidator.getZone('400001');     // "Maharashtra / MP / Chhattisgarh / Goa"
PincodeValidator.validate('012345');    // "Cannot start with 0"
```

---

### UPI / VPA

```dart
UpiValidator.validate('viraj@okicici');          // null ✅
UpiValidator.validate('9876543210@paytm');        // null ✅
UpiValidator.getHandle('viraj@okicici');          // "okicici"
UpiValidator.isKnownHandle('viraj@paytm');        // true
```

---

## All Supported Validators via Facade

```dart
IndianValidators.pan(value)
IndianValidators.aadhaar(value)
IndianValidators.mobile(value)
IndianValidators.gst(value)
IndianValidators.ifsc(value)
IndianValidators.pincode(value)
IndianValidators.upi(value)

// Boolean helpers
IndianValidators.isValidPan(value)
IndianValidators.isValidAadhaar(value)
IndianValidators.isValidMobile(value)
IndianValidators.isValidGst(value)
IndianValidators.isValidIfsc(value)
IndianValidators.isValidPincode(value)
IndianValidators.isValidUpi(value)
```

---

## Why This Package?

Building Indian fintech apps means constantly writing the same regex patterns and rules. This package gives you:

- **Zero dependencies** — no bloat, no conflicts
- **Null-safe** — fully sound Dart null safety
- **Flutter-ready** — validators return `String?` so they plug directly into `TextFormField`
- **Utility extras** — not just validation, but formatting, masking, and data extraction
- **Tested** — comprehensive unit tests for all validators

---

## Contributing

Issues and PRs are welcome! Please open an issue before submitting large changes.

---

## License

BSD 3-Clause — see [LICENSE](LICENSE)
