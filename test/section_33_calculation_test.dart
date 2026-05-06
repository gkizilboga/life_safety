import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/screens/bolum_33_screen.dart';

void main() {
  group('Bölüm 33: Kullanıcı Yükü ve Çıkış Sayısı Hesaplama Testleri (BYKHY)', () {
    
    test('Senaryo 1: Merdiven Genişliği Otomatik Seçim Testi', () {
      expect(Bolum33Screen.minMerdivGenisligi(50), 0.90);
      expect(Bolum33Screen.minMerdivGenisligi(500), 1.20);
      expect(Bolum33Screen.minMerdivGenisligi(1500), 1.50);
      expect(Bolum33Screen.minMerdivGenisligi(13000), 2.00);
    });

    test('Senaryo 2: Merdiven Gerektiren Kat (Merdiven Hesabı)', () {
      // Örnek: 300 kişi
      // Toplam Genişlik = 300 * 0.5 / 60 = 2.5 m
      // Min Merdiven Genişliği (300 kişi için) = 1.2 m
      // Gerekli Adet = ceil(2.5 / 1.2) = 3
      expect(Bolum33Screen.hesaplaMerdivenSayisi(300), 3);

      // Örnek: 50 kişi
      // Toplam Genişlik = 50 * 0.5 / 60 = 0.416 m
      // Min Merdiven Genişliği (50 kişi için) = 0.9 m
      // Gerekli Adet = ceil(0.416 / 0.9) = 1
      expect(Bolum33Screen.hesaplaMerdivenSayisi(50), 1);
    });

    test('Senaryo 3: Kullanıcının 13.000 Kişilik Örneği (Doğrulama)', () {
      // Yük = 13.000 kişi
      // Toplam Genişlik = 13.000 * 0.5 / 60 = 108.33 m
      // Min Merdiven Genişliği (>2000 kişi için) = 2.0 m
      // Gerekli Adet = ceil(108.33 / 2.0) = 55
      expect(Bolum33Screen.hesaplaMerdivenSayisi(13000), 55);
    });

    test('Senaryo 4: Doğrudan Dışarı Çıkış Olan Kat (Kapı Hesabı - 0.9m bazlı)', () {
      // Örnek: 200 kişi
      // Toplam Genişlik = 200 * 0.5 / 100 = 1.0 m
      // Kapı Genişliği = 0.9 m
      // Gerekli Adet = ceil(1.0 / 0.9) = ceil(1.11) = 2
      expect(Bolum33Screen.hesaplaKapiSayisi(200), 2);

      // Örnek: 1000 kişi
      // Toplam Genişlik = 1000 * 0.5 / 100 = 5.0 m
      // Gerekli Adet = ceil(5.0 / 0.9) = ceil(5.55) = 6
      expect(Bolum33Screen.hesaplaKapiSayisi(1000), 6);
    });

    test('Senaryo 5: Küçük Yüklerde Minimum Kapı Sayısı', () {
      // Örnek: 10 kişi
      // Toplam Genişlik = 10 * 0.5 / 100 = 0.05 m
      // Gerekli Adet = ceil(0.05 / 0.9) = 1
      expect(Bolum33Screen.hesaplaKapiSayisi(10), 1);
    });
  });
}
