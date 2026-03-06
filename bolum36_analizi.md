# Bölüm 36 (Kaçış Merdivenleri) Detaylı Mantık Analiz Raporu

Bölüm 36 ile ilgili tüm Dart dosyaları (Modeller, Handler, Screen, Provider) baştan sona incelenmiş ve aşağıdaki bulgular saptanmıştır.

## 1. Tespit Edilen Kritik Hatalar ve Eksiklikler

### A. [EKSİKLİK] Dairesel Merdiven Kova Genişliği Girişi Yok
- **Durum:** `Bolum20Model` ve `Section36Handler` içerisinde dairesel merdivenler için "100 cm kova genişliği" kuralı (Madde 44) uygulanıyor. Ancak `Bolum20Screen` ve `Bolum20Provider` üzerinde bu verinin girilebileceği hiçbir alan bulunmuyor.
- **Sonuç:** Kullanıcı merdiven genişliğini beyan edemiyor, sistem bu değeri hep `0` veya `null` olarak görüyor, bu da yanlış değerlendirmelere yol açabilir.

### B. [HATA] Genişlik Karşılaştırma Kararsızlığı (Optimistik Mantık)
- **Durum:** `bolum_36_screen.dart` içerisinde genişlik kontrolü `sRange[1] < minMerdiven` (Aralığın üst sınırı minimumdan küçükse hata ver) şeklinde yapılıyor.
- **Örnek:** Gereken min. genişlik 150 cm ise ve kullanıcı "120-150 cm arası" (Merd-B) seçerse; `150 < 150` false döner ve **HATA VERİLMEMİŞ OLUR**. Oysa bu aralıkta merdiven 125 cm de olabilir ve bu durumda yönetmeliğe aykırıdır.
- **Öneri:** `sRange[0] < minMerdiven` (Aralığın alt sınırı minimumdan küçükse risk uyarısı ver) şeklinde daha güvenli (conservative) tarafa geçilmeli.

### C. [TUTARSIZLIK] Yükseklik Kontrollerinde Veri Farklılığı
- **Durum:** `Section36Handler` korunumlu merdiven zorunluluğunu (21.50m - 30.50m eşikleri) kontrol ederken SADECE `hYapi` (Yapı Yüksekliği) değerine bakıyor. Ancak `bolum_36_screen.dart` aynı eşikler için hem `hBina` hem `hYapi` değerlerini (EĞER birisi bile aşılmışsa "Yüksek Bina" kabul ederek) kullanıyor.
- **Sonuç:** Ekranda "Gereken: 150cm" yazarken, PDF raporunda "Uygundur" yazabilir.

### D. [MANTIKSAL EKSİKLİK] "Bilmiyorum" Yanıtlarının Raporlanmaması
- **Durum:** Madde 41 (Lobi mesafesi ve %50 tahliye kuralı) için kullanıcı "Bilmiyorum" seçeneğini işaretlediğinde, `Section36Handler` bu durumu rapor parçalarına eklemiyor (pas geçiyor).
- **Sonuç:** Raporun o kısmında hiçbir bilgi oluşmuyor ve kullanıcı belirsizliğin farkına varamıyor.

### E. [VERİ HATASI] Dairesel Merdiven Yük Çıkarsaması
- **Durum:** Dairesel merdivenler için max 25 kişi kuralı, o kattaki toplam kullanıcı yüküne (`maxYuk`) göre kontrol ediliyor.
- **Örnek:** Zemin katı 5000 kişilik bir bina olsun, ama 3. katta 2 odaya hizmet veren bir dairesel merdiven olsun. Sistem bu merdiveni "5000 kişiye hizmet ediyor" sanıp hata veriyor.
- **Öneri:** Merdivene özel yük bilgisi şu an modelde yok, ancak en azından açıklama metninde bu durum "Mahal bazlı yük kontrol edilmelidir" şeklinde esnetilmeli.

---

## 2. Planlanan İyileştirmeler

1. **`bolum_20_screen.dart` & `bolum_20_provider.dart`**: Dairesel (spiral) merdiven seçildiğinde görünecek şekilde "Kova Genişliği (cm)" input alanı eklenecek.
2. **`Section36Handler.dart`**: 
   - Korunumlu merdiven adedi hesabı, "Yüksek Bina" tanımıyla (hem hBina hem hYapi kontrolü) uyumlu hale getirilecek.
   - Madde 41 mesafeleri için "BİLİNMİYOR" durumu rapor metinlerine eklenecek.
   - Dairesel merdiven yük uyarısı "binanın toplam yükü" yerine "merdivenin hizmet verdiği yük" vurgusuyla güncellenecek.
   - `Section36Handler` içine Bölüm 36 ekranındaki genişlik kontrollerini kopyalayıp (Merdiven, Koridor, Kapı) **merkezi** hale getireceğiz.
3. **`bolum_36_screen.dart`**:
   - Genişlik ihlal mantığı `sRange[0] < minMerdiven` olarak güncellenecek.
   - Ekran üzerindeki manuel metin kurgusu, motor (Handler) ile daha senkronize çalışacak; mümkünse ekran sadece `note` üretecek, asıl karar Handler'da kalacak.

Analiz onaylanırsa uygulamaya geçilecektir.
