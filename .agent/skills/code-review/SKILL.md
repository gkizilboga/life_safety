---
name: code-review
description: Performs a comprehensive code review focused on security, performance, and best practices.
---

# Code Review Skill (Senior QA Perspective)

Bu skill, projedeki kod değişikliklerini hem yazılımsal kalite hem de iş (domain) güvenliği açısından sistematik bir şekilde incelemek ve uygulamak için tasarlanmıştır.

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

---

## Davranışsal İlkeler ve Uygulama Prensipleri

Bu prensipler, yaygın kodlama hatalarını azaltmak için "hızdan ziyade temkinli olmayı" esas alır.

### 1. Kodlamadan Önce Analiz Et
Varsayımlarda bulunma, belirsizliği gizleme.
- Uygulamaya geçmeden önce varsayımlarını açıkça belirt. Şüphen varsa sor.
- Birden fazla çözüm yolu varsa, birini sessizce seçmek yerine seçenekleri sun.
- Daha basit bir yaklaşım varsa belirt; gerektiğinde mevcut talebe yapıcı bir şekilde itiraz et.

### 2. Önce Sadelik (Simplicity First)
Problemi çözen minimum kod; spekülatif hiçbir şey ekleme.
- İstenen dışında ekstra özellik ekleme.
- Tek seferlik kullanılacak kodlar için karmaşık soyutlamalar yapma.
- Talep edilmeyen "esneklik" veya "konfigüre edilebilirlik" unsurlarından kaçın.
- İmkansız senaryolar için hata yönetimi (error handling) yazma.
- **Kritik Soru:** "Kıdemli bir mühendis buna 'aşırı karmaşık' der miydi?" Cevabın evetse, sadeleştir.

### 3. Cerrahi Müdahaleler (Surgical Changes)
Sadece gereken yere dokun. Sadece kendi değiştirdiğin kısımları temizle.
- Mevcut kodu düzenlerken; komşu kodları, yorum satırlarını veya formatı "iyileştirmeye" çalışma.
- Bozuk olmayan şeyi refactor etme.
- Kendi tarzın farklı olsa bile mevcut kod stiline uyum sağla.
- Eğer senin değişikliklerin bazı importları/değişkenleri boşa çıkarırsa onları sil; ancak senden önce var olan atıl kodlara dokunma (istenmediği sürece).

### 4. Hedef Odaklı İlerleme
Başarı kriterlerini tanımla ve doğrulanana kadar döngüde kal.
- Görevleri doğrulanabilir hedeflere dönüştür: "Doğrulama ekle" yerine "Geçersiz girdiler için test yaz ve geçmesini sağla."
- Çok adımlı görevlerde kısa bir plan sun:
  1. [Adım] -> Doğrulama yöntemi: [Kontrol]
  2. [Adım] -> Doğrulama yöntemi: [Kontrol]

---

## Kullanım Talimatları

1. İncelemek istediğiniz dosyayı `view_file` ile okuyun.
2. `resources/review_template.md` dosyasını referans alarak bir rapor hazırlayın.
3. Bulduğunuz sorunları **Etki Analizi** ile birlikte (Sorun -> Potansiyel Risk) sınıflandırın.
4. Önem derecelerini (Düşük, Orta, Yüksek) belirlerken can güvenliği (Life Safety) risklerini önceliklendirin.
5. Yukarıdaki **Davranışsal İlkeleri** hem inceleme yaparken hem de kod önerirken bir anayasa olarak kabul edin.