enum ItfaiyeMesafeSecim { gecmiyor, geciyor, bilmiyorum }
enum EngelDurumuSecim { engelYok, engelVar, bilmiyorum }
enum ZayifGecisSecim { varSecenek, yokSecenek }

class Bolum11Model {
  final ItfaiyeMesafeSecim? resItfaiyeMesafe;
  final EngelDurumuSecim? resEngelDurumu;
  final ZayifGecisSecim? resZayifGecis;

  Bolum11Model({
    this.resItfaiyeMesafe,
    this.resEngelDurumu,
    this.resZayifGecis,
  });

  String get raporMesaji {
    if (resItfaiyeMesafe == ItfaiyeMesafeSecim.gecmiyor) {
      return "✅ OLUMLU GÖRÜNÜYOR. İtfaiye yaklaşım mesafesi uygun (Tüm cepheler 45 metre menzil içerisinde).";
    }
    if (resItfaiyeMesafe == ItfaiyeMesafeSecim.bilmiyorum) {
      return "⚠️ UYARI. Uzman Görüşü alınması tavsiye edilir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir.";
    }
    if (resItfaiyeMesafe == ItfaiyeMesafeSecim.geciyor) {
      if (resEngelDurumu == EngelDurumuSecim.engelYok) {
        return "✅ OLUMLU GÖRÜNÜYOR.";
      }
      if (resEngelDurumu == EngelDurumuSecim.bilmiyorum) {
        return "⚠️ UYARI. Mesafenin aşılmasının sebebinin duvar olup olmadığı bilinmiyor. Kontrol edilmesi ve Uzman Görüşü alınması tavsiye edilir.";
      }
      if (resEngelDurumu == EngelDurumuSecim.engelVar) {
        if (resZayifGecis == ZayifGecisSecim.varSecenek) {
          return "Duvar, çit, kapı vb. engeli var ancak yıkılabilir geçiş bölgesi mevcut. Lütfen bu alanın önüne araç park edilmemesine dikkat ediniz.";
        }
        if (resZayifGecis == ZayifGecisSecim.yokSecenek) {
          return "🚨 KIRMIZI RİSK: İtfaiye erişimini engelleyen duvarlarda, acil durum geçişi için zayıflatılmış ve işaretlenmiş özel bir bölüm bulunmak zorundadır. Aksi takdirde itfaiye binaya ulaşamaz.";
        }
      }
    }
    return "";
  }

  Bolum11Model copyWith({
    ItfaiyeMesafeSecim? resItfaiyeMesafe,
    EngelDurumuSecim? resEngelDurumu,
    ZayifGecisSecim? resZayifGecis,
  }) {
    return Bolum11Model(
      resItfaiyeMesafe: resItfaiyeMesafe ?? this.resItfaiyeMesafe,
      resEngelDurumu: resEngelDurumu ?? this.resEngelDurumu,
      resZayifGecis: resZayifGecis ?? this.resZayifGecis,
    );
  }
}