import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum9Model {
  final ChoiceResult? secim;
  final ChoiceResult? davlumbaz;

  Bolum9Model({this.secim, this.davlumbaz});

  Bolum9Model copyWith({ChoiceResult? secim, ChoiceResult? davlumbaz}) {
    return Bolum9Model(
      secim: secim ?? this.secim,
      davlumbaz: davlumbaz ?? this.davlumbaz,
    );
  }

  Map<String, dynamic> toMap() {
    return {'secim_label': secim?.label, 'davlumbaz_label': davlumbaz?.label};
  }

  factory Bolum9Model.fromMap(Map<String, dynamic> map) {
    final label = map['secim_label'];
    ChoiceResult? sprinklerSecim;
    if (label == Bolum9Content.tamKapsam.label)
      sprinklerSecim = Bolum9Content.tamKapsam;
    if (label == Bolum9Content.yok.label) sprinklerSecim = Bolum9Content.yok;
    if (label == Bolum9Content.kismen.label)
      sprinklerSecim = Bolum9Content.kismen;

    ChoiceResult? davlumbazSecim;
    final dLabel = map['davlumbaz_label'];
    if (dLabel == Bolum9Content.davlumbazVar.label)
      davlumbazSecim = Bolum9Content.davlumbazVar;
    if (dLabel == Bolum9Content.davlumbazYok.label)
      davlumbazSecim = Bolum9Content.davlumbazYok;
    if (dLabel == Bolum9Content.davlumbazBilmiyorum.label)
      davlumbazSecim = Bolum9Content.davlumbazBilmiyorum;

    return Bolum9Model(secim: sprinklerSecim, davlumbaz: davlumbazSecim);
  }
}
