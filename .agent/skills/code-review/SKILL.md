---
name: code-review
description: Performs a comprehensive code review focused on security, performance, and best practices.
---

# Code Review Skill

Bu skill, projedeki kod değişikliklerini sistematik bir şekilde incelemek için tasarlanmıştır.

## İnceleme Kriterleri

### 1. Güvenlik (Security)
- Kaynak kodda hassas bilgi (API anahtarı, şifre vb.) var mı?
- Kullanıcıdan alınan veriler doğrulanıyor mu? (Input validation)
- Potansiyel SQL enjeksiyonu veya XSS riskleri var mı?

### 2. Performans (Performance)
- Gereksiz döngüler veya pahalı işlemler var mı?
- Bellek yönetimi (özellikle Flutter'da widget ağacı ve stream kullanımı) optimize edilmiş mi?
- Veritabanı sorguları verimli mi?

### 3. Kod Kalitesi ve Standartlar (Code Quality)
- Değişken ve fonksiyon isimlendirmeleri anlamlı mı? (CamelCase, snake_case vb. kurallara uyum)
- Fonksiyonlar çok mu uzun? (SRP - Single Responsibility Principle)
- Kodda yeterli yorum satırı var mı?

### 4. Hata Yönetimi (Error Handling)
- `try-catch` blokları doğru kullanılmış mı?
- Hata durumlarında kullanıcıya anlamlı geri bildirim veriliyor mu?

## Kullanım Talimatları

1. İncelemek istediğiniz dosyayı `view_file` ile okuyun.
2. `resources/review_template.md` dosyasını referans alarak bir rapor hazırlayın.
3. Bulduğunuz sorunları önem derecesine göre (Düşük, Orta, Yüksek) sınıflandırın.
