import 'package:flutter/services.dart';

class InputValidator {
  /// Hem nokta hem virgülü kabul eden ve 2 ondalık basamağa izin veren formatter.
  /// Not: Görünümde her ikisine izin verir, parsing aşamasında nokta ile birleştirilir.
  static TextInputFormatter get flexDecimal =>
      FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]\d{0,2})?'));

  /// Sadece pozitif tam sayılara izin veren formatter
  static TextInputFormatter get positiveInteger =>
      FilteringTextInputFormatter.digitsOnly;

  /// Girdideki virgülleri noktaya çevirerek güvenli parse işlemi yapar.
  static double? parseFlex(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }

  /// Sayısal değer kontrolü
  static String? validateNumber(
    String? value, {
    required double min,
    required double max,
    String unit = "",
    bool isRequired = true,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? "Lütfen bir değer giriniz." : null;
    }

    final n = parseFlex(value);

    if (n == null) {
      return "Geçerli bir sayı giriniz.";
    }

    if (n < 0) {
      return "Negatif değer girilemez.";
    }

    if (n < min) {
      return "Minimum değer $min $unit olmalıdır.";
    }

    if (n > max) {
      return "Maksimum değer $max $unit olarak girilebilir.";
    }

    return null;
  }

  /// Alan ve hesaplama sonuçlarını standart görünüme kavuşturur (örn: 1.234,56)
  static String formatArea(double value) {
    bool isNegative = value < 0;
    String str = value.abs().toStringAsFixed(2);
    List<String> parts = str.split('.');
    String intPart = parts[0];
    String decPart = parts.length > 1 ? parts[1] : '00';

    String formattedInt = '';
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        formattedInt += '.';
      }
      formattedInt += intPart[i];
    }

    return "${isNegative ? '-' : ''}$formattedInt,$decPart";
  }
}
