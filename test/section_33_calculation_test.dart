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
      // BYKHY Madde 39: 51-500 kişi arası en az 2 çıkış.
      expect(Bolum33Screen.hesaplaMerdivenSayisi(300), 2);

      // Örnek: 50 kişi
      // BYKHY Madde 39: 0-50 kişi arası en az 1 çıkış.
      expect(Bolum33Screen.hesaplaMerdivenSayisi(50), 1);
    });

    test('Senaryo 3: Kullanıcının 13.000 Kişilik Örneği (Doğrulama)', () {
      // Yük = 13.000 kişi (> 1500) -> Genişlik hesabı devrede.
      // Toplam Genişlik = 13.000 * 0.5 / 60 = 108.33 m
      // Min Merdiven Genişliği (>1500 kişi için) = 2.0 m
      // Gerekli Adet = ceil(108.33 / 2.0) = 55
      expect(Bolum33Screen.hesaplaMerdivenSayisi(13000), 55);
    });

    test('Senaryo 4: Doğrudan Dışarı Çıkış Olan Kat (Kapı Hesabı)', () {
      // Örnek: 200 kişi (51-500) -> 2 çıkış
      expect(Bolum33Screen.hesaplaKapiSayisi(200), 2);

      // Örnek: 1000 kişi (501-1000) -> 3 çıkış
      expect(Bolum33Screen.hesaplaKapiSayisi(1000), 3);
    });

    test('Senaryo 5: Küçük Yüklerde Minimum Kapı Sayısı', () {
      // Örnek: 10 kişi
      // Toplam Genişlik = 10 * 0.5 / 100 = 0.05 m
      // Gerekli Adet = ceil(0.05 / 0.9) = 1
      expect(Bolum33Screen.hesaplaKapiSayisi(10), 1);
    });
  });
}
