# Bölüm 36 (Merdiven Değerlendirmesi) Raporlama Analizi

Bölüm 36, uygulamanın en karmaşık hesaplama mantığına sahip bölümlerinden biridir. Yaptığım inceleme sonucunda, Özet Ekranı ile PDF çıktısı arasındaki ifade farklılıklarının temel nedenlerini ve çözüm önerilerimi aşağıda detaylandırdım.

## Tespit Edilen Nedenler

### 1. Raporlama Yollarının Parçalı Yapısı
Uygulamada raporlama üç farklı kanal üzerinden yapılıyor ve Bölüm 36 bu kanallarda farklı seviyelerde işleniyor:
- **Özet Ekranı (`getSectionSummary`):** Şu an Bölüm 36 için özel bir mantık içermiyor. Sadece kullanıcının seçtiği ana seçeneğin ismini (label) döndürüyor. Bu yüzden çok "yüzeysel" kalıyor.
- **PDF Çıktısı (`getSectionFullReport`):** Madde 41, dışa açılma oranları ve korunumlu merdiven sayıları gibi çok derin analizler yapıp bunu bir metin bloğu olarak sunuyor.
- **Detaylı Görünüm (`getSectionDetailedReport`):** UI'daki "Detaylar" kısmında ise genişlik ölçüleri ve çıkış katı gibi veriler tek tek madde madde listeleniyor.

### 2. "Derinlemesine Analiz" vs "Beyan" Farkı
PDF çıktısı, kullanıcının girdiği ham verileri (Bölüm 20 Merdiven Sayıları, Bölüm 4 Bina Yüksekliği vb.) alıp yönetmelik süzgecinden geçirerek bir "Mühendislik Analizi" üretir. Özet ekranı ise sadece Bölüm 36 sorusuna verilen "Yanıtı" gösterir.

## Öneri ve Metodoloji

Bilgilerin hem doğru hem de daha uyumlu hissettirmesi için şu yöntemi öneriyorum:

### 1. Ortak Değerlendirme Motoru (Unified Logic)
Bölüm 36 analizini yapan mantığı tek bir yardımcı "Handler" sınıfına veya metoduna toplayalım. 
- Özet ekranı bu motordan **"Kısa Özet"** (Örn: "Yetersiz dış çıkış oranı (%20)") alsın.
- PDF bu motordan **"Uzun Analiz"** alsın.
- Detay ekranı bu motordan **"Maddeleştirilmiş Veri"** alsın.

### 2. Özet Ekranı İyileştirmesi
Özet ekranında sadece "Değerlendirme yapıldı" yazması yerine, PDF'deki kritik bulgulardan birer cümlelik "flash" bilgiler çekilebilir:
- *Örnek:* "Bina yüksekliği nedeniyle 2 korunumlu merdiven zorunlu (Mevcut: 1)."

### 3. İfade Standartlaştırması
`AppContent` veya `ReportEngine` içerisinde Bölüm 36 için kullanılan "KRİTİK RİSK", "UYARI" gibi ön eklerin ve cümle yapılarının şablonlarını (template) eşitlemeliyiz.

## Sonuç
Bölüm 36'daki bu farklılık aslında bir "hata" değil, bir "kapsam derinliği" farkıdır. Ancak kullanıcı deneyimi açısından özet ekranının da PDF'deki o akıllı analizden ipuçları vermesi kesinlikle daha profesyonel duracaktır. Onay verirseniz, `getSectionSummary` metoduna Bölüm 36 için "akıllı özet" mantığını ekleyebilirim.
