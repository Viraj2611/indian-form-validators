import 'package:test/test.dart';
import 'package:indian_form_validators/indian_form_validators.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // PAN
  // ─────────────────────────────────────────────────────────────────────────
  group('PanValidator', () {
    test('valid PAN returns null', () {
      expect(PanValidator.validate('ABCDE1234F'), isNull);
      expect(PanValidator.validate('AAPFU0939F'), isNull);
      expect(PanValidator.validate('BZAHM6385P'), isNull);
    });

    test('lowercase PAN is normalized and valid', () {
      expect(PanValidator.validate('abcde1234f'), isNull);
    });

    test('null or empty returns error', () {
      expect(PanValidator.validate(null), isNotNull);
      expect(PanValidator.validate(''), isNotNull);
      expect(PanValidator.validate('   '), isNotNull);
    });

    test('wrong length returns error', () {
      expect(PanValidator.validate('ABCDE123'), isNotNull);
      expect(PanValidator.validate('ABCDE12345F'), isNotNull);
    });

    test('invalid format returns error', () {
      expect(
          PanValidator.validate('1BCDE1234F'), isNotNull); // starts with digit
      expect(
          PanValidator.validate('ABCDE123FF'), isNotNull); // two letters at end
      expect(PanValidator.validate('ABCDE1234@'), isNotNull); // special char
    });

    test('isValid mirrors validate', () {
      expect(PanValidator.isValid('ABCDE1234F'), isTrue);
      expect(PanValidator.isValid('INVALID'), isFalse);
    });

    test('getTaxpayerType returns correct type', () {
      // A A A [P] A 1 2 3 4 C → index 3 = 'P' → Individual (Person)
      expect(PanValidator.getTaxpayerType('AAAPA1234C'),
          equals('Individual (Person)'));
      // A A A [C] A 1 2 3 4 C → index 3 = 'C' → Company
      expect(PanValidator.getTaxpayerType('AAACA1234C'), equals('Company'));
      // A A A [H] A 1 2 3 4 C → index 3 = 'H' → HUF
      expect(PanValidator.getTaxpayerType('AAAHA1234C'),
          equals('Hindu Undivided Family (HUF)'));
    });

    test('getTaxpayerType returns null for invalid PAN', () {
      expect(PanValidator.getTaxpayerType('INVALID'), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Aadhaar
  // ─────────────────────────────────────────────────────────────────────────
  group('AadhaarValidator', () {
    // Verhoeff-valid Aadhaar test numbers (publicly known test values)
    const validAadhaar = '499118665246';

    test('valid Aadhaar returns null', () {
      expect(AadhaarValidator.validate(validAadhaar), isNull);
    });

    test('Aadhaar with spaces is accepted', () {
      expect(AadhaarValidator.validate('4991 1866 5246'), isNull);
    });

    test('null or empty returns error', () {
      expect(AadhaarValidator.validate(null), isNotNull);
      expect(AadhaarValidator.validate(''), isNotNull);
    });

    test('wrong length returns error', () {
      expect(AadhaarValidator.validate('12345678901'), isNotNull); // 11 digits
      expect(
          AadhaarValidator.validate('1234567890123'), isNotNull); // 13 digits
    });

    test('starting with 0 or 1 returns error', () {
      expect(AadhaarValidator.validate('012345678901'), isNotNull);
      expect(AadhaarValidator.validate('112345678901'), isNotNull);
    });

    test('non-digit characters return error', () {
      expect(AadhaarValidator.validate('1234567890AB'), isNotNull);
    });

    test('invalid checksum returns error', () {
      expect(AadhaarValidator.validate('499118665247'), isNotNull); // off by 1
    });

    test('isValid mirrors validate', () {
      expect(AadhaarValidator.isValid(validAadhaar), isTrue);
      expect(AadhaarValidator.isValid('123456789012'), isFalse);
    });

    test('format returns XXXX XXXX XXXX', () {
      expect(AadhaarValidator.format(validAadhaar), equals('4991 1866 5246'));
    });

    test('mask hides first 8 digits', () {
      expect(AadhaarValidator.mask(validAadhaar), equals('XXXX XXXX 5246'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Mobile
  // ─────────────────────────────────────────────────────────────────────────
  group('MobileValidator', () {
    test('valid 10-digit numbers return null', () {
      expect(MobileValidator.validate('9876543210'), isNull);
      expect(MobileValidator.validate('6012345678'), isNull);
      expect(MobileValidator.validate('7890123456'), isNull);
      expect(MobileValidator.validate('8123456789'), isNull);
    });

    test('+91 prefix is stripped and validated', () {
      expect(MobileValidator.validate('+919876543210'), isNull);
    });

    test('0 prefix is stripped and validated', () {
      expect(MobileValidator.validate('09876543210'), isNull);
    });

    test('91 prefix is stripped for 12-digit numbers', () {
      expect(MobileValidator.validate('919876543210'), isNull);
    });

    test('null or empty returns error', () {
      expect(MobileValidator.validate(null), isNotNull);
      expect(MobileValidator.validate(''), isNotNull);
    });

    test('numbers starting with 1-5 return error', () {
      expect(MobileValidator.validate('5876543210'), isNotNull);
      expect(MobileValidator.validate('1234567890'), isNotNull);
    });

    test('wrong length returns error', () {
      expect(MobileValidator.validate('987654321'), isNotNull); // 9 digits
      expect(MobileValidator.validate('98765432101'), isNotNull); // 11 digits
    });

    test('isValid mirrors validate', () {
      expect(MobileValidator.isValid('9876543210'), isTrue);
      expect(MobileValidator.isValid('1234567890'), isFalse);
    });

    test('normalize returns clean 10-digit number', () {
      expect(MobileValidator.normalize('+919876543210'), equals('9876543210'));
      expect(MobileValidator.normalize('09876543210'), equals('9876543210'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GST
  // ─────────────────────────────────────────────────────────────────────────
  group('GstValidator', () {
    test('valid GST numbers return null', () {
      expect(GstValidator.validate('27AAPFU0939F1ZV'), isNull);
      expect(GstValidator.validate('29AABCT1332L1ZD'), isNull);
      expect(GstValidator.validate('07AAACP0165G2ZQ'), isNull);
    });

    test('lowercase GST is normalized and valid', () {
      expect(GstValidator.validate('27aapfu0939f1zv'), isNull);
    });

    test('null or empty returns error', () {
      expect(GstValidator.validate(null), isNotNull);
      expect(GstValidator.validate(''), isNotNull);
    });

    test('wrong length returns error', () {
      expect(GstValidator.validate('27AAPFU0939F1Z'), isNotNull); // 14 chars
      expect(GstValidator.validate('27AAPFU0939F1ZVX'), isNotNull); // 16 chars
    });

    test('invalid state code returns error', () {
      expect(GstValidator.validate('99AAPFU0939F1ZV'),
          isNotNull); // 99 is other territory
    });

    test('isValid mirrors validate', () {
      expect(GstValidator.isValid('27AAPFU0939F1ZV'), isTrue);
      expect(GstValidator.isValid('INVALID'), isFalse);
    });

    test('getState returns correct state', () {
      expect(GstValidator.getState('27AAPFU0939F1ZV'), equals('Maharashtra'));
      expect(GstValidator.getState('07AAACP0165G2ZQ'), equals('Delhi'));
    });

    test('extractPan returns embedded PAN', () {
      expect(GstValidator.extractPan('27AAPFU0939F1ZV'), equals('AAPFU0939F'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // IFSC
  // ─────────────────────────────────────────────────────────────────────────
  group('IfscValidator', () {
    test('valid IFSC codes return null', () {
      expect(IfscValidator.validate('HDFC0001234'), isNull);
      expect(IfscValidator.validate('SBIN0005943'), isNull);
      expect(IfscValidator.validate('ICIC0001234'), isNull);
    });

    test('lowercase IFSC is normalized and valid', () {
      expect(IfscValidator.validate('hdfc0001234'), isNull);
    });

    test('null or empty returns error', () {
      expect(IfscValidator.validate(null), isNotNull);
      expect(IfscValidator.validate(''), isNotNull);
    });

    test('wrong length returns error', () {
      expect(IfscValidator.validate('HDFC001234'), isNotNull); // 10 chars
      expect(IfscValidator.validate('HDFC00012345'), isNotNull); // 12 chars
    });

    test('5th character not 0 returns error', () {
      expect(IfscValidator.validate('HDFC1001234'), isNotNull);
    });

    test('isValid mirrors validate', () {
      expect(IfscValidator.isValid('HDFC0001234'), isTrue);
      expect(IfscValidator.isValid('INVALID'), isFalse);
    });

    test('getBankName returns known bank', () {
      expect(IfscValidator.getBankName('HDFC0001234'), equals('HDFC Bank'));
      expect(IfscValidator.getBankName('SBIN0005943'),
          equals('State Bank of India'));
    });

    test('getBankCode returns first 4 characters', () {
      expect(IfscValidator.getBankCode('HDFC0001234'), equals('HDFC'));
    });

    test('getBranchCode returns last 6 characters', () {
      expect(IfscValidator.getBranchCode('HDFC0001234'), equals('001234'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Pincode
  // ─────────────────────────────────────────────────────────────────────────
  group('PincodeValidator', () {
    test('valid pincodes return null', () {
      expect(PincodeValidator.validate('400001'), isNull); // Mumbai
      expect(PincodeValidator.validate('110001'), isNull); // Delhi
      expect(PincodeValidator.validate('560001'), isNull); // Bengaluru
    });

    test('null or empty returns error', () {
      expect(PincodeValidator.validate(null), isNotNull);
      expect(PincodeValidator.validate(''), isNotNull);
    });

    test('pincode starting with 0 returns error', () {
      expect(PincodeValidator.validate('012345'), isNotNull);
    });

    test('wrong length returns error', () {
      expect(PincodeValidator.validate('40000'), isNotNull); // 5 digits
      expect(PincodeValidator.validate('4000011'), isNotNull); // 7 digits
    });

    test('non-digits return error', () {
      expect(PincodeValidator.validate('4000A1'), isNotNull);
    });

    test('isValid mirrors validate', () {
      expect(PincodeValidator.isValid('400001'), isTrue);
      expect(PincodeValidator.isValid('000000'), isFalse);
    });

    test('getZone returns correct zone description', () {
      expect(PincodeValidator.getZone('400001'), contains('Maharashtra'));
      expect(PincodeValidator.getZone('110001'), contains('Delhi'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // UPI
  // ─────────────────────────────────────────────────────────────────────────
  group('UpiValidator', () {
    test('valid UPI IDs return null', () {
      expect(UpiValidator.validate('viraj@okicici'), isNull);
      expect(UpiValidator.validate('9876543210@paytm'), isNull);
      expect(UpiValidator.validate('name.surname@ybl'), isNull);
      expect(UpiValidator.validate('user_123@oksbi'), isNull);
      expect(UpiValidator.validate('user-name@ibl'), isNull);
    });

    test('null or empty returns error', () {
      expect(UpiValidator.validate(null), isNotNull);
      expect(UpiValidator.validate(''), isNotNull);
    });

    test('missing @ returns error', () {
      expect(UpiValidator.validate('virajokicici'), isNotNull);
    });

    test('multiple @ returns error', () {
      expect(UpiValidator.validate('viraj@@okicici'), isNotNull);
      expect(UpiValidator.validate('vi@raj@okicici'), isNotNull);
    });

    test('too short username returns error', () {
      expect(
          UpiValidator.validate('ab@okicici'), isNotNull); // username < 3 chars
    });

    test('isValid mirrors validate', () {
      expect(UpiValidator.isValid('viraj@okicici'), isTrue);
      expect(UpiValidator.isValid('invalid'), isFalse);
    });

    test('getUsername extracts correct part', () {
      expect(UpiValidator.getUsername('viraj@okicici'), equals('viraj'));
    });

    test('getHandle extracts correct part', () {
      expect(UpiValidator.getHandle('viraj@okicici'), equals('okicici'));
    });

    test('isKnownHandle identifies common handles', () {
      expect(UpiValidator.isKnownHandle('viraj@okicici'), isTrue);
      expect(UpiValidator.isKnownHandle('viraj@paytm'), isTrue);
      expect(UpiValidator.isKnownHandle('viraj@unknownbank'), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // IndianValidators facade
  // ─────────────────────────────────────────────────────────────────────────
  group('IndianValidators facade', () {
    test('pan delegates correctly', () {
      expect(IndianValidators.pan('ABCDE1234F'), isNull);
      expect(IndianValidators.pan('INVALID'), isNotNull);
    });

    test('mobile delegates correctly', () {
      expect(IndianValidators.mobile('9876543210'), isNull);
      expect(IndianValidators.mobile('1234567890'), isNotNull);
    });

    test('ifsc delegates correctly', () {
      expect(IndianValidators.ifsc('HDFC0001234'), isNull);
      expect(IndianValidators.ifsc('INVALID'), isNotNull);
    });

    test('pincode delegates correctly', () {
      expect(IndianValidators.pincode('400001'), isNull);
      expect(IndianValidators.pincode('000000'), isNotNull);
    });

    test('upi delegates correctly', () {
      expect(IndianValidators.upi('viraj@okicici'), isNull);
      expect(IndianValidators.upi('invalid'), isNotNull);
    });

    test('isValidPan boolean helper works', () {
      expect(IndianValidators.isValidPan('ABCDE1234F'), isTrue);
      expect(IndianValidators.isValidPan('INVALID'), isFalse);
    });
  });
}
