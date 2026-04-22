import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../utils/app_theme.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Future<Uint8List> Function(PdfPageFormat) onLayout;
  final String title;
  final String fileName;

  const PdfPreviewScreen({
    super.key,
    required this.onLayout,
    required this.title,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: PdfPreview(
        build: onLayout,
        canDebug: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        pdfFileName: fileName,
        loadingWidget: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
        ),
        // PdfPreview widget'ı varsayılan olarak Share ve Print aksiyonlarını sunar.
        // canShare: true varsayılan değerdir.
      ),
    );
  }
}
