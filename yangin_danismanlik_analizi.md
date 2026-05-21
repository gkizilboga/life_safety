# 🔥 Yangın Danışmanı Perspektifi: Uygulama Boşluk Analizi

> Konut ve konut+ticaret yapıları odağında, BYKHY (Binaların Yangından Korunması Hakkında Yönetmelik) ve ilgili standartlar çerçevesinde yapılan kapsamlı değerlendirme.

---

## ✅ Mevcut Güçlü Yönler (Kısaca)

Önce doğru yaptıklarınızı teslim etmek gerekiyor:
- Yapı yüksekliği/bina yüksekliği ayrımı doğru kullanılıyor
- Yangın güvenlik holü, itfaiye asansörü, basınçlandırma mantıkları kurulmuş
- Kaçış merdiveni tipleri ve korunumlu merdiven gereksinimleri işlenmiş
- Otopark, kazan dairesi, depo gibi riskli hacimler için alan bazlı analiz var
- Kullanıcı yükü hesaplaması katsayı bazlı yapılıyor
- Sprinkler, yangın dolabı, hidrant gibi sistemlerin eşik mantığı yazılmış

---

## 🚨 ÖNCELİK 1 — KRİTİK BOŞLUKLAR (Piyasaya çıkmadan önce mutlaka eklenmeli)

### 1. 🏢 Yangın Kompartımanı ve Bölme Kapısı Değerlendirmesi YOK

Bu **en kritik eksik**tir. Yönetmelik konut binalarında her katta (ve özellikle konut+ticaret karmasında) yangın kompartımanı sınırlarını belirler. Uygulamanızda:

- **Bölüm 14** yalnızca "Tesisat Şaftları" kapıyor — şaft duvarı/kapak dayanımını hesaplıyor. **İyi.**
- Ancak **koridorlar, apartman kapıları, katlardaki yangın bölme duvarları, kompartıman büyüklük sınırları** hiç sorgulanmıyor.

**Yönetmeliğin ne dediği:**
- BYKHY Madde 26: Yangın kompartımanı alanı konutlarda ≤ 2400 m², karma kullanımlarda daha düşük
- Ticari-konut arası bölme duvarı: minimum 120 dakika EI dayanımı
- Yangın bölme kapısı: minimum 90 dakika (EI 90-C) — **daire kapılarını da kapsamaktadır**

**Ne sorulmalı:**
- Daire giriş kapısı yangın dayanımlı mı ve kaç dakikalık? (EI30/EI60/EI90)
- Ticari kat ile konut kat arasındaki döşeme/duvarın yangın dayanımı yeterli mi?
- Binada kompartıman alanı sınırı aşılıyor mu?

---

### 2. 🪜 Kaçış Yolu Boyunca Yanıcı Malzeme Yasağı — EKSIK

Bölüm 15'te zemin kaplama ve yalıtım var, ancak **kaçış yolu** (koridor, merdiven yuvası) özelindeki malzeme sınırlaması sorgulanmıyor.

**Yönetmeliğin ne dediği:**
- BYKHY Madde 32: Kaçış yollarında duvar/tavan kaplamaları B1 veya daha az yanıcı olmalı
- Ahşap kaplama, tekstil vb. kaçış koridorlarında yasak
- Kaçış yolu koridorlarında yanıcı eşya bırakılması yasak (işletim/denetim konusu ama risk sorulabilir)

**Bu neden önemli:** Gerçek ölümlerin büyük çoğunluğu merdiven yuvası/koridor boyunca yayılan duman/alevden kaynaklanır.

---

### 3. 🔌 Elektrik Tesisatı Yangın Güvenliği — HIÇ YOK

Bölüm 31 (Trafo), Bölüm 32 (Jeneratör) var ama **genel elektrik tesisatı yangın güvenliği** sorgulanmıyor.

**Yönetmeliğin ne dediği (ve gerçek sahada ne görüyoruz):**
- Pano odaları yangına dayanıklı malzemeden yapılmalı (≥ 60 dk)
- Kablo kanalları yangın bölmelerinden geçerken yangın mastiklenmeli
- Acil durum aydınlatma bağımsız beslemeli olmalı
- Bölüm 29'da "Elektrik Panosu" sorgulanıyor — **ama yalnızca yanıcı madde açısından**, tesisat güvenliği açısından değil.

**Ne sorulmalı:**
- Daire elektrik panolarına bireysel yangın koruma uygulanmış mı?
- Genel pano odası yangına dayanıklı oda içinde mi?
- Kablo yangın bariyer uygulaması (fire stop) yapılmış mı?

---

### 4. 🚪 Yangın Kapısının Fiziksel Özellikleri — EKSİK

Bölüm 27'de "Kaçış Yolu Kapıları" başlığı var — **yön, genişlik** sorgulanıyor. Ancak:

- Kapının **yangın dayanım süresi (EI30/EI60/EI90)** sorulmuyor
- Kapının **otomatik kapanıcısı (door closer)** var mı sorulmuyor
- Kapının **duman sızdırmazlığı (smoke seal)** var mı sorulmuyor
- Özellikle **konut+ticaret** yapılarında servis ve depo kapılarının yangın kapısı olması zorunluluğu sorgulanmıyor

**Bu neden kritik:** Yangın kapısının %90 sahada sorun olarak gördüğüm şey şu — kapı doğru tipte ama açık bırakılmış ya da door closer yok. Bunu sorgu olarak eklemek gerçek değer katar.

---

## ⚠️ ÖNCELİK 2 — ÖNEMLİ BOŞLUKLAR (İlk versiyondan sonra eklenmeli)

### 5. 🏪 Ticari Kat Özel Gereksinimleri — KISMI

Konut+ticaret (karma) binalar için:
- **Ticari birimin kaçış yolu zemine inip inmediği** analiz edilmiyor (ticari brim kendi bağımsız kaçışa sahip mi?)
- **Ticari birimlerin birbirinden ayrımı** (kompartıman) sorgulanmıyor
- **Büyük mağaza, süpermarket benzeri** yüksek yoğunluklu kullanım için ayrı kurallar var (BYKHY Bölüm 7, madde 42 sonrası) — bunlar için yük katsayısı farklı ve uygulamanızda zaten kısmen var ama tüm özel durumlar ele alınmıyor

### 6. 🅿️ Otopark Özel Sorgulama — EKSİK KONULAR

Otopark için boyut bazlı sorgulama iyi. Ancak:

- **Açık/yarı açık otopark** için sprinkler muafiyeti net sorgulanmıyor (Yönetmelik açık otoparkları muaf tutabilir — bu kriteri daha net işleyin)
- **Elektrikli araç şarj istasyonları** — artık yeni binalarda bu konu gündeme geliyor ve yangın riski farklı. Yakın gelecekte sorulması gereken bir madde.
- **Otopark içi rampa güvenliği** (yangın kompartımanı açısından) sorgulanmıyor

### 7. 💨 Havalandırma Sistemi Yangın Güvenliği — KISMI

Bölüm 20'de basınçlandırma sorgulanmıyor. Ancak:

- **HVAC (merkezi iklimlendirme/havalandırma) kanallarının** yangın bölmelerini delip geçtiği noktalar için damper zorunluluğu genel bir uyarı olarak var (active systems), ama **bina bazında havalandırma sistemi var mı** sorusu hiç sorulmuyor.
- Konut+ticaret yapılarında **ortak havalandırma bacası** yangın yayılım riski — özellikle ticari mutfak bacaları — var mı sorusu eksik.

### 8. ♿ Engelliler İçin Tahliye — HİÇ YOK

Bu konu Yönetmeliğin kapsamı dışında olabilir ama **piyasada sizi eleştirebilecek** bir boşluktur:

- Tekerlekli sandalye kullanan kişiler için kaçış merdiveni başında "alan of rescue" (güvenli bekleme alanı) var mı?
- Engelli araç parkı ile bina girişi yangın güvenliği açısından ele alınmıyor.

---

## 📋 ÖNCELİK 3 — TAMAMLAYICI KONULAR (Gelecek versiyonlar)

### 9. 📋 Yangın Güvenliği Yönetimi / İşletim Planı

Yönetmelik sadece yapısal koşulları değil, **işletim şartlarını** da kapsar:

- **Tahliye tatbikatı zorunluluğu** — Kaç kişi var, yılda kaç tatbikat yapılmalı?
- **Bina Yangın Güvenlik Sorumlusu** atanması zorunluluğu (belirli büyüklükteki binalarda)
- **Yangın önleme planı / tahliye planı** zorunluluğu

Bu konu uygulamanızın kapsamı dışında olabilir ama **raporun sonuna bir not veya hatırlatma eklemek** değer katar.

### 10. 🌡️ Isıl Köprü ve Dış Cephe Yangın Yayılımı — KISMI

Bölüm 16'da "Dış Cephe" var. Ancak:

- Yalnızca cephe malzemesi soruluyor gibi görünüyor
- **Yangının kattan kata dışarıdan yayılmasını önleyen bant (yangın bariyeri / fire break)** uygulaması var mı sorulmuyor. Konut binalarında özellikle EPS, XPS gibi yanıcı yalıtım malzemeleri ciddi risk oluşturuyor (Grenfell Tower örneği).
- Pencere/cephe birleşim noktalarında yangın mastiki/bariyeri uygulaması sorgulanmıyor.

### 11. 🔋 UPS / Acil Güç Kaynağı Yangın Güvenliği

Bölüm 32 (Jeneratör) var. Ancak:

- **UPS odaları** (büyük lityum pil/akü sistemleri) ayrı bir yangın riski oluşturuyor
- Günümüzde büyük binalarda yaygın olan bu sistemler için sorgulama yok

### 12. 🌿 Yeşil Çatı / Güneş Paneli — YENİ RİSK ALANI

Bölüm 17'de çatılar sorgulanıyor. Ancak:

- **Fotovoltaik (güneş paneli) sistemler** yangın riski açısından özel bir kategori — ülkemizde hızla yaygınlaşıyor
- Çatıya monte güneş paneli olan binalarda itfaiyenin erişimi ve panel kaynaklı yangın riski sorgulanmıyor

---

## 🔍 MANTIK / HESAPLAMA HATALARI VE RİSKLİ VARSAYIMLAR

### L1. Algılama Sistemi Eşiği — Konut İstisnaları Atlanmış Olabilir

```
// active_systems_engine.dart satır 72-88
if (hYapi >= 51.50) {
  → ZORUNLU
} else {
  → ZORUNLU DEĞİL
}
```

**Sorun:** BYKHY'de konutlar dışındaki kullanım tiplerine (ticari alanlar, depo vs.) bağlı olarak **51.50m altında da** algılama zorunlu olabilir. Ticari alanlı karma binalar için bu eşik yeterince kapsamlı değil.

**Önerilen düzeltme:** `hasTicari == true` ise ayrı bir kural seti değerlendirmeye alınmalı.

### L2. Sprinkler — Yüksek Yoğunluklu Ticari Alanlar İçin Eksik Kural

Sprinkler mantığı yalnızca yapı yüksekliği (≥51.50m) ve otopark alanına (≥600m²) bakıyor. Oysa **yüksek yoğunluklu ticari alanlar** (örn. büyük mağaza, toplantı salonu) için yüksekliğe bakılmaksızın sprinkler zorunlu olabilir.

### L3. Acil Yönlendirme — Tek Çıkış İstisnaları

```
// Satır 115-132
if (cikisSayisi > 1) → ZORUNLU
else → ZORUNLU DEĞİL
```

Tek çıkışlı binalarda bile Yönetmelik bazı durumlarda yönlendirme işaretleri istiyor. "Önerilir" notu var ama bu biraz daha güçlü bir uyarı olabilirdi.

### L4. Elle İhbar Sistemi Eşiği — Karışık İfade

```
if (hBina >= 21.50 || hYapi >= 30.50) → ZORUNLU
```

Bu kural BYKHY Madde 66/1-a'yı doğru yansıtıyor. Ancak Madde 66/1-d'ye göre **kullanıcı yükü > 200 kişi** olan binalarda da bu zorunlu. Bu kural **elle ihbar için eksik**, acil aydınlatmada ise doğru uygulanmış.

---

## 📊 ÖZET ÖNCELİK TABLOSU

| # | Konu | Öncelik | BYKHY Maddesi | Etki |
|---|------|---------|---------------|------|
| 1 | Yangın kompartımanı/bölme kapısı dayanımı | 🔴 KRİTİK | Md. 26, 27 | Çok Yüksek |
| 2 | Kaçış yolunda yanıcı malzeme | 🔴 KRİTİK | Md. 32 | Yüksek |
| 3 | Elektrik tesisatı yangın güvenliği | 🔴 KRİTİK | Md. 50-55 | Yüksek |
| 4 | Yangın kapısı fiziksel özellikleri | 🔴 KRİTİK | Md. 28-29 | Yüksek |
| 5 | Ticari kat bağımsız kaçışı | 🟠 ÖNEMLİ | Md. 36-38 | Orta-Yüksek |
| 6 | Açık otopark sprinkler muafiyeti | 🟠 ÖNEMLİ | Md. 94 | Orta |
| 7 | HVAC/havalandırma sistemi varlığı | 🟠 ÖNEMLİ | Md. 99 | Orta |
| 8 | Algılama: ticari alan düşük eşiği | 🟠 ÖNEMLİ | Md. 64 | Orta |
| 9 | Elle ihbar: yük >200 kişi kuralı | 🟠 ÖNEMLİ | Md. 66 | Orta |
| 10 | Engelli tahliyesi / güvenli bekleme | 🟡 TAMAMLAYICI | Md. 31 | Düşük-Orta |
| 11 | Cephe yangın bariyeri (fire break) | 🟡 TAMAMLAYICI | Md. 56 | Orta |
| 12 | Tahliye planı / tatbikat zorunluluğu | 🟡 TAMAMLAYICI | Md. 123 | Düşük |
| 13 | Güneş paneli / yeşil çatı riski | 🟡 TAMAMLAYICI | Ek Md. | Düşük |

---

## 💡 GENEL DEĞERLENDİRME

Uygulamanız **sektörde mevcut benzer araçlardan çok daha kapsamlı ve teknik olarak doğru** bir temel üzerine kurulmuş. 36 bölümün varlığı, kaçış merdiveni tip analizi, yükseklik bazlı eşikler ve aktif sistemler motoru — bunlar gerçekten iyi düşünvelerle şekillenmiş.

**Piyasaya çıkmadan önce mutlaka kapatılması gereken 4 alan:**
1. Yangın kompartımanı / bölme kapısı dayanımı sorgulaması
2. Kaçış yolu malzeme güvenliği
3. Yangın kapısının fiziksel özellikleri (dayanım + kapatıcı + duman sızdırmazlığı)
4. Elle ihbar için "kullanıcı yükü > 200" kuralının eklenmesi

Bu 4 boşluk kapatılırsa uygulamanız rakiplere kıyasla **savunulabilir bir kapsamda** piyasaya çıkabilir. Diğerleri rekabet avantajı sağlayan özellikler olarak ilerleyen versiyonlara bırakılabilir.
