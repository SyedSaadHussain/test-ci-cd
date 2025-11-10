class VisitType {
  final String label;
  final int value;
  final int surveyId;
  final List<Stage> stages;

  VisitType({required this.label, required this.value, required this.surveyId, required this.stages});

  factory VisitType.fromJson(Map<String, dynamic> json) {
    return VisitType(
      label: json['label'],
      value: json['value'],
      surveyId: json['survey_id'],
      stages: (json['stages'] as List).map((e) => Stage.fromJson(e)).toList(),
    );
  }
}


class Stage {
  final String label;
  final int value;
  final int sequence;
  final int stageId;
  final bool isDefault;


  Stage({required this.label, required this.value, required this.sequence, required this.stageId,    this.isDefault = false,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      label: json['label'],
      value: json['value'],
      sequence: json['sequence'],
      stageId: json['stage_id'],
      isDefault:  json['is_default']?? false,
    );
  }
}

