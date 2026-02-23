import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum2Model {
  final ChoiceResult? secim;

  Bolum2Model({this.secim});

  Bolum2Model copyWith({ChoiceResult? secim}) {
    return Bolum2Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim_label': secim?.label};
  }

  factory Bolum2Model.fromMap(Map<String, dynamic> map) {
    final label = map['secim_label'];

    // Etikete göre doğru nesneyi bulup getiriyoruz
    if (label == Bolum2Content.betonarme.label)
      return Bolum2Model(secim: Bolum2Content.betonarme);
    if (label == Bolum2Content.celik.label)
      return Bolum2Model(secim: Bolum2Content.celik);
    if (label == Bolum2Content.ahsap.label)
      return Bolum2Model(secim: Bolum2Content.ahsap);
    if (label == Bolum2Content.yigma.label)
      return Bolum2Model(secim: Bolum2Content.yigma);
    if (label == Bolum2Content.bilinmiyor.label)
      return Bolum2Model(secim: Bolum2Content.bilinmiyor);

    return Bolum2Model();
  }
}
