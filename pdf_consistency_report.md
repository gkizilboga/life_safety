# PDF Çıktı Formatı İnceleme Raporu

**Tarih:** 2026-01-24
**İncelenen Dosya:** `lib/services/pdf_service.dart`

## Özet
Risk Analizi (36 Bölüm) ve Aktif Sistem Gereksinimleri PDF çıktılarının temel altyapısı (Fontlar, Kapak yapısı, Yasal sayfa) tutarlı görünse de, görsel tasarım ve döküman detaylarında bazı önemli farklılıklar tespit edilmiştir.

## Karşılaştırmalı Analiz

| Özellik | Risk Analizi PDF | Aktif Sistem PDF | Durum |
| :--- | :--- | :--- | :--- |
| **Font Ailesi** | Roboto (Regular/Bold) | Roboto (Regular/Bold) | ✅ Tutarlı |
| **Ana Başlık Rengi** | `PdfColors.blue900` | `PdfColors.purple900` | ⚠️ Farklı |
| **Ana Başlık Boyutu** | `12 pt` | `16 pt` | ⚠️ Farklı |
| **Alt Bilgi (Footer)** | Var (Versiyon + Sayfa No) | Eksik | ❌ Tutarsız |
| **Üst Bilgi (Header)** | Boş | "Aktif Sistem Gereksinimleri" | ⚠️ Farklı |
| **Sayfa Kenarı Filigranı**| "RESMİ EVRAK DEĞİLDİR" | "RESMİ EVRAK DEĞİLDİR" | ✅ Tutarlı |

## Tespit Edilen Tutarsızlıklar

### [YÜKSEK] Alt Bilgi (Footer) Eksikliği
- **Açıklama:** Risk Analizi raporunda sayfa numarası ve versiyon bilgisini içeren şık bir footer bulunurken, Aktif Sistem raporunda bu footer tanımlanmamıştır.
- **Öneri:** `generateRiskAnalysisPdf` içindeki footer kodu `generateActiveSystemsPdf` metoduna da kopyalanmalı veya merkezi bir helper fonksiyona taşınmalıdır.

### [ORTA] Renk ve Boyut Farklılığı
- **Açıklama:** Risk Analizi mavi (`blue900`) temalı ve mütevazı bir başlık boyutu (12) kullanırken, Aktif Sistem mor (`purple900`) temalı ve daha büyük bir başlık (16) kullanmaktadır.
- **Öneri:** Kurumsal kimlik bütünlüğü için her iki raporda da aynı renk paleti ve başlık hiyerarşisi kullanılmalıdır.

### [DÜŞÜK] Üst Bilgi (Header) Tutarsızlığı
- **Açıklama:** Risk Analizi raporunun header'ı boş bırakılmışken, Aktif Sistem raporunda bölüm ismi yazmaktadır.
- **Öneri:** Her iki raporda da üst bilgide raporun adı ve tarih gibi bilgiler standart bir şekilde yer almalıdır.

## Sonuç
Raporlar yapısal olarak benzer ancak görsel olarak "farklı uygulamalara" aitmiş gibi durmaktadır. Marka bütünlüğü için renk ve footer senkronizasyonu yapılması önerilir.
