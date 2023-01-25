
class RegularExpression{
  RegularExpression();
  static const String nepalPhonePattern = r'(?:\(?\+977\)?)?[9][6-9]\d{8}|01[-]?[0-9]{7}.{10}$';
  static const String otpPattern = r'^(?=.*?[0-9]).{6}$';
}
