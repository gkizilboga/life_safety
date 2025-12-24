import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum18Model {
  final ChoiceResult? duvarKaplama;
  final ChoiceResult? boruTipi; // Sadece yüksek binalarda sorulur

  Bolum18Model({
    this.duvarKaplama,
    this.boruTipi,
  });

  Bolum18Model copyWith({
    ChoiceResult? duvarKaplama,
    ChoiceResult? boruTipi,
  }) {
    return Bolum18Model(
      duvarKaplama: duvarKaplama ?? this.duvarKaplama,
      boruTipi: boruTipi ?? this.boruTipi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'duvarKaplama_label': duvarKaplama?.label,
      'boruTipi_label': boruTipi?.label,
    };
  }

  factory Bolum18Model.fromMap(Map<String, dynamic> map) {
    // Duvar Kaplama
    ChoiceResult? d;
    final l1 = map['duvarKaplama_label'];
    if (l1 == Bolum18Content.duvarOptionA.label) d = Bolum18Content.duvarOptionA;
    else if (l1 == Bolum18Content.duvarOptionB.label) d = Bolum18Content.duvarOptionB;
    else if (l1 == Bolum18Content.duvarOptionC.label) d = Bolum18Content.duvarOptionC;
    else if (l1 == Bolum18Content.duvarOptionD.label) d = Bolum18Content.duvarOptionD;

    // Boru Tipi
    ChoiceResult? b;
    final l2 = map['boruTipi_label'];
    if (l2 == Bolum18Content.boruOptionA.label) b = Bolum18Content.boruOptionA;
    else if (l2 == Bolum18Content.boruOptionB.label) b = Bolum18Content.boruOptionB;
    else if (l2 == Bolum18Content.boruOptionC.label) b = Bolum18Content.boruOptionC;
    else if (l2 == Bolum18Content.boruOptionD.label) b = Bolum18Content.boruOptionD;

    return Bolum18Model(
      duvarKaplama: d,
      boruTipi: b,
    );
  }
}