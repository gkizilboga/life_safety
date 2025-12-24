import 'choice_result.dart'; // Aynı klasörde
import '../utils/app_content.dart'; // İki nokta var, dikkat!

class Bolum1Model {
  final ChoiceResult? secim;

  Bolum1Model({this.secim});

  bool? get isYeniBina {
    if (secim == null) return null;
    return secim?.label == Bolum1Content.ruhsatSonrasi.label;
  }

  Bolum1Model copyWith({ChoiceResult? secim}) {
    return Bolum1Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim_label': secim?.label};
  }
  
  factory Bolum1Model.fromMap(Map<String, dynamic> map) {
    final label = map['secim_label'];
    if (label == Bolum1Content.ruhsatSonrasi.label) {
      return Bolum1Model(secim: Bolum1Content.ruhsatSonrasi);
    } else if (label == Bolum1Content.ruhsatOncesi.label) {
      return Bolum1Model(secim: Bolum1Content.ruhsatOncesi);
    }
    return Bolum1Model();
  }
}