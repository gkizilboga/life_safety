import 'package:flutter/services.dart';

class PdfAssets {
  static ByteData? _fontData;
  static ByteData? _fontDataBold;
  static ByteData? _fontDataItalic;
  static ByteData? _fontDataBoldItalic;
  static ByteData? _logoData;

  static Future<void> ensureAssetsLoaded() async {
    _fontData ??= await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    _fontDataBold ??= await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    _fontDataItalic ??= await rootBundle.load("assets/fonts/Roboto-Italic.ttf");
    _fontDataBoldItalic ??= await rootBundle.load("assets/fonts/Roboto-BoldItalic.ttf");
    _logoData ??= await rootBundle.load("assets/images/ui/logo3.webp");
  }

  static ByteData get fontData => _fontData!;
  static ByteData get fontDataBold => _fontDataBold!;
  static ByteData get fontDataItalic => _fontDataItalic!;
  static ByteData get fontDataBoldItalic => _fontDataBoldItalic!;
  static ByteData get logoData => _logoData!;
}
