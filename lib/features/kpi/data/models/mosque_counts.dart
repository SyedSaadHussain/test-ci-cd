class MosqueCounts {
  final int employeeId;
  final int userId;
  final int classificationId;
  final int parentId;
  final int allMosques;
  final int draftMosques;
  final int inprogressMosques;
  final int doneMosques;
  final int canceledMosques;

  MosqueCounts({
    required this.employeeId,
    required this.userId,
    required this.classificationId,
    required this.parentId,
    required this.allMosques,
    required this.draftMosques,
    required this.inprogressMosques,
    required this.doneMosques,
    required this.canceledMosques,
  });

  factory MosqueCounts.fromJson(Map<String, dynamic> json) {
    return MosqueCounts(
      employeeId: json['employee_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      classificationId: json['classification_id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      allMosques: json['all_mosques'] ?? 0,
      draftMosques: json['draft_mosques'] ?? 0,
      inprogressMosques: json['inprogress_mosques'] ?? 0,
      doneMosques: json['done_mosques'] ?? 0,
      canceledMosques: json['canceled_mosques'] ?? 0,
    );
  }

  // Check if the data object is empty or has no actual data
  bool get hasData => allMosques > 0;

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'user_id': userId,
      'classification_id': classificationId,
      'parent_id': parentId,
      'all_mosques': allMosques,
      'draft_mosques': draftMosques,
      'inprogress_mosques': inprogressMosques,
      'done_mosques': doneMosques,
      'canceled_mosques': canceledMosques,
    };
  }
}
