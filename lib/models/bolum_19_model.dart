import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum19Model {
  final List<ChoiceResult> engeller;
  final ChoiceResult? levha;
  final ChoiceResult? yanilticiKapi;
  final ChoiceResult? yanilticiEtiket;

  ChoiceResult? get engel => engeller.isNotEmpty ? engeller.first : null;

  Bolum19Model({
    this.engeller = const [],
    this.levha,
    this.yanilticiKapi,
    this.yanilticiEtiket,
  });

  Bolum19Model copyWith({
    List<ChoiceResult>? engeller,
    ChoiceResult? levha,
    ChoiceResult? yanilticiKapi,
    ChoiceResult? yanilticiEtiket,
  }) {
    return Bolum19Model(
      engeller: engeller ?? this.engeller,
      levha: levha ?? this.levha,
      yanilticiKapi: yanilticiKapi ?? this.yanilticiKapi,
      yanilticiEtiket: yanilticiEtiket ?? this.yanilticiEtiket,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'engeller_labels': engeller.map((e) => e.label).toList(),
      'levha_label': levha?.label,
      'yanilticiKapi_label': yanilticiKapi?.label,
      'yanilticiEtiket_label': yanilticiEtiket?.label,
    };
  }

  factory Bolum19Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l) {
      if (l == null) return null;
      final allChoices = [
        Bolum19Content.engelOptionA, Bolum19Content.engelOptionB, 
        Bolum19Content.engelOptionC, Bolum19Content.engelOptionD,
        Bolum19Content.levhaOptionA, Bolum19Content.levhaOptionB, Bolum19Content.levhaOptionC,
        Bolum19Content.yanilticiOptionA, Bolum19Content.yanilticiOptionB,
        Bolum19Content.etiketOptionA, Bolum19Content.etiketOptionB, Bolum19Content.etiketOptionC,
      ];
      
      for (var choice in allChoices) {
        if (choice.label == l) return choice;
      }
      return null;
    }

    List<ChoiceResult> eList = [];
    if (map['engeller_labels'] != null) {
      eList = (map['engeller_labels'] as List)
          .map((l) => find(l.toString()))
          .where((e) => e != null)
          .cast<ChoiceResult>()
          .toList();
    }

    return Bolum19Model(
      engeller: eList,
      levha: find(map['levha_label']),
      yanilticiKapi: find(map['yanilticiKapi_label']),
      yanilticiEtiket: find(map['yanilticiEtiket_label']),
    );
  }
}