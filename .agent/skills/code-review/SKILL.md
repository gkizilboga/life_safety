---
name: code-review
description: Performs a comprehensive code review focused on security, performance, and best practices.
---

# Code Review Skill (Senior QA Perspective)

Bu skill, projedeki kod değişikliklerini hem yazılımsal kalite hem de iş (domain) güvenliği açısından sistematik bir şekilde incelemek için tasarlanmıştır.

## İnceleme Kriterleri

### 1. Güvenlik ve Veri Bütünlüğü (Security & Data Integrity)
- Kaynak kodda hassas bilgi (API anahtarı, şifre vb.) var mı?
- Kullanıcıdan alınan veriler doğrulanıyor mu? (Input validation)
- **Karakter Seti Güvenliği:** Türkçe karakterlere duyarlı (İ/i, I/ı) string işlemleri güvenli yapılmış mı? (`_textToLevel` gibi helperlar kullanılıyor mu?)
- **Null Safety:** Dart/Flutter null-safety kurallarına (`?`, `!`, `??`) uygun ve güvenli mi?

### 2. Performans ve Ölçeklenebilirlik (Performance)
- Gereksiz döngüler, pahalı işlemler veya tekrarlanan widget build'leri var mı?
- Bellek yönetimi (Stream subscription'ların kapatılması, dispose işlemleri) yapılmış mı?
- Veritabanı (BinaStore/SharedPreferences) erişimleri optimize mi?

### 3. Mühendislik ve Regülasyon Uyumu (Domain Logic)
- **Hesaplama Hassasiyeti:** Kat yükseklikleri, alan hesapları gibi `double` işlemlerde hassasiyet kaybı riski var mı?
- **Yönetmelik Referansları:** Kod içindeki mantık, BYKHY (Binaların Yangından Korunması Hakkında Yönetmelik) maddeleriyle uyumlu mu ve referans verilmiş mi?

### 4. Test Edilebilirlik (Testability)
- Kod birim testleri (Unit Tests) yazılmasına uygun mu? (Bağımlılıklar kolayca mock'lanabiliyor mu?)
- Mevcut test suite'i (`flutter test`) üzerinde regresyon riski var mı?
- Kritik iş kuralları (Business rules) için otomatik test senaryoları mevcut mu?

### 5. UI/UX Standartları ve Erişilebilirlik
- Kod, projenin merkezi tasarım sistemiyle (`AppColors`, `AppStyles`) uyumlu mu?
- Responsive tasarım kurallarına uyulmuş mu? (Overflow kontrolleri).

### 6. Kod Kalitesi ve Hata Yönetimi
- **SRP (Single Responsibility):** Fonksiyonlar ve sınıflar sadece tek bir işten mi sorumlu?
- **Error Handling:** `try-catch` blokları anlamlı mı? Kullanıcıya risk analizini bozmayacak net geri bildirimler veriliyor mu?

## Kullanım Talimatları

1. İncelemek istediğiniz dosyayı `view_file` ile okuyun.
2. `resources/review_template.md` dosyasını referans alarak bir rapor hazırlayın.
3. Bulduğunuz sorunları **Etki Analizi** ile birlikte (Sorun -> Potansiyel Risk) sınıflandırın.
4. Önem derecelerini (Düşük, Orta, Yüksek) belirlerken can güvenliği (Life Safety) risklerini önceliklendirin.
