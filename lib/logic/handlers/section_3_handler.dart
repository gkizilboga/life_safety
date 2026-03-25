import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/models/report_status.dart';

class Section3Handler {
  final BinaStore _store;

  Section3Handler(this._store);

  List<Map<String, dynamic>> getDetailedReport() {
    List<Map<String, dynamic>> details = [];
    final b3 = _store.bolum3;

    if (b3 == null) return details;

    // Kat sayıları
    final int normalKat = b3.normalKatSayisi ?? 0;
    final int bodrumKat = b3.bodrumKatSayisi ?? 0;
    final int toplamKat = normalKat + bodrumKat + 1; // +1 zemin

    if (normalKat > 0) {
      details.add({
        'label': 'Normal Kat Sayısı (Zemin Üstü)',
        'value': '$normalKat adet',
        'report': '',
        'status': ReportStatus.info,
      });
    }
    if (bodrumKat > 0) {
      details.add({
        'label': 'Bodrum Kat Sayısı (Zemin Altı)',
        'value': '$bodrumKat adet',
        'report': '',
        'status': ReportStatus.info,
      });
    }
    details.add({
      'label': 'Zemin Kat',
      'value': '1 adet',
      'report': '',
      'status': ReportStatus.info,
    });
    details.add({
      'label': 'Toplam Kat Adedi',
      'value': '$toplamKat kat',
      'report': '',
      'status': ReportStatus.info,
    });

    // Kat yükseklikleri
    details.add({
      'label': 'Zemin Kat Yüksekliği',
      'value': '${b3.zeminYuksekligi?.toStringAsFixed(2) ?? "-"} m',
      'report': '',
      'status': ReportStatus.info,
    });
    if (normalKat > 0) {
      details.add({
        'label': 'Normal Kat Yüksekliği (1 kat için)',
        'value': '${b3.normalYuksekligi?.toStringAsFixed(2) ?? "-"} m',
        'report': '',
        'status': ReportStatus.info,
      });
    }
    if (bodrumKat > 0) {
      details.add({
        'label': 'Bodrum Kat Yüksekliği (1 kat için)',
        'value': '${b3.bodrumYuksekligi?.toStringAsFixed(2) ?? "-"} m',
        'report': '',
        'status': ReportStatus.info,
      });
    }

    // Bina ve yapı yükseklikleri
    details.add({
      'label': 'Bina Yüksekliği (hBina)',
      'value': '${b3.hBina?.toStringAsFixed(2) ?? "-"} m',
      'report': '',
      'status': ReportStatus.info,
    });
    details.add({
      'label': 'Yapı Yüksekliği (hYapı)',
      'value': '${b3.hYapi?.toStringAsFixed(2) ?? "-"} m',
      'report': '',
      'status': ReportStatus.info,
    });

    // Yüksek bina sınıflandırması
    final bool isYuksek = b3.isYuksekBina;
    details.add({
      'label': 'Yüksek Bina Statüsü',
      'value': isYuksek ? 'YÜKSEK BİNA' : 'Yüksek Olmayan Bina',
      'report': '',
      'status': ReportStatus.info,
    });

    // Varsayılan değer uyarısı
    if (b3.yukseklikBilinmiyor == true) {
      details.add({
        'label': 'Kat Yükseklikleri',
        'value': 'Uygulama tarafından varsayılan değerler kullanılsın.',
        'report':
            'NOT: Kat yükseklikleri kullanıcı tarafından bilinmediğinden Uygulama tarafından varsayılan değerler (Zemin: 3.50 m, Normal: 3.00 m, Bodrum: 3.50 m) kullanılarak hesaplamalar yapılmıştır.',
        'status': ReportStatus.info,
      });
    }

    return details;
  }
}
