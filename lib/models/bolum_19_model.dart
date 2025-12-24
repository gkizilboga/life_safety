import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum19Model {
  final ChoiceResult? engel;
  final ChoiceResult? levha;
  final ChoiceResult? yanilticiKapi;
  final bool? yanilticiEtiketVar; // Alt soru için

  Bolum19Model({
    this.engel,
    this.levha,
    this.yanilticiKapi,
    this.yanilticiEtiketVar,
  });

  Bolum19Model copyWith({
    ChoiceResult? engel,
    ChoiceResult? levha,
    ChoiceResult? yanilticiKapi,
    bool? yanilticiEtiketVar,
  }) {
    return Bolum19Model(
      engel: engel ?? this.engel,
      levha: levha ?? this.levha,
      yanilticiKapi: yanilticiKapi ?? this.yanilticiKapi,
      yanilticiEtiketVar: yanilticiEtiketVar ?? this.yanilticiEtiketVar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'engel_label': engel?.label,
      'levha_label': levha?.label,
      'yanilticiKapi_label': yanilticiKapi?.label,
      'yanilticiEtiketVar': yanilticiEtiketVar,
    };
  }

  factory Bolum19Model.fromMap(Map<String, dynamic> map) {
    // Engel
    ChoiceResult? e;
    final l1 = map['engel_label'];
    if (l1 == Bolum19Content.engelOptionA.label) e = Bolum19Content.engelOptionA;
    else if (l1 == Bolum19Content.engelOptionB.label) e = Bolum19Content.engelOptionB;
    else if (l1 == Bolum19Content.engelOptionC.label) e = Bolum19Content.engelOptionC;
    else if (l1 == Bolum19Content.engelOptionD.label) e = Bolum19Content.engelOptionD;

    // Levha
    ChoiceResult? l;
    final l2 = map['levha_label'];
    if (l2 == Bolum19Content.levhaOptionA.label) l = Bolum19Content.levhaOptionA;
    else if (l2 == Bolum19Content.levhaOptionB.label) l = Bolum19Content.levhaOptionB;
    else if (l2 == Bolum19Content.levhaOptionC.label) l = Bolum19Content.levhaOptionC;

    // Yanıltıcı Kapı
    ChoiceResult? y;
    final l3 = map['yanilticiKapi_label'];
    if (l3 == Bolum19Content.yanilticiOptionA.label) y = Bolum19Content.yanilticiOptionA;
    else if (l3 == Bolum19Content.yanilticiOptionB.label) y = Bolum19Content.yanilticiOptionB;

    return Bolum19Model(
      engel: e,
      levha: l,
      yanilticiKapi: y,
      yanilticiEtiketVar: map['yanilticiEtiketVar'],
    );
  }
}