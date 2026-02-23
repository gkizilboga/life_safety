import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum9Model {
  final ChoiceResult? secim;

  Bolum9Model({this.secim});

  Bolum9Model copyWith({ChoiceResult? secim}) {
    return Bolum9Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim_label': secim?.label};
  }

  factory Bolum9Model.fromMap(Map<String, dynamic> map) {
    final label = map['secim_label'];
    if (label == Bolum9Content.tamKapsam.label)
      return Bolum9Model(secim: Bolum9Content.tamKapsam);
    if (label == Bolum9Content.yok.label)
      return Bolum9Model(secim: Bolum9Content.yok);
    if (label == Bolum9Content.kismen.label)
      return Bolum9Model(secim: Bolum9Content.kismen);
    return Bolum9Model();
  }
}
