class VisitsDraftCounts {
  final int userId;
  final int parentId;
  final int employeeId;
  final int classificationId;
  final int totalLandVisit;
  final int totalDraftEidVisit;
  final int totalDraftVisitsAll;
  final int totalDraftJummaVisit;
  final int totalDraftRegularVisit;
  final int totalDraftOndemandVisit;

  const VisitsDraftCounts({
    required this.userId,
    required this.parentId,
    required this.employeeId,
    required this.classificationId,
    required this.totalLandVisit,
    required this.totalDraftEidVisit,
    required this.totalDraftVisitsAll,
    required this.totalDraftJummaVisit,
    required this.totalDraftRegularVisit,
    required this.totalDraftOndemandVisit,
  });

  factory VisitsDraftCounts.fromJson(Map<String, dynamic> json) {
    return VisitsDraftCounts(
      userId: json['user_id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      classificationId: json['classification_id'] ?? 0,
      totalLandVisit: json['total_land_visit'] ?? 0,
      totalDraftEidVisit: json['total_draft_eid_visit'] ?? 0,
      totalDraftVisitsAll: json['total_draft_visits_all'] ?? 0,
      totalDraftJummaVisit: json['total_draft_jumma_visit'] ?? 0,
      totalDraftRegularVisit: json['total_draft_regular_visit'] ?? 0,
      totalDraftOndemandVisit: json['total_draft_ondemand_visit'] ?? 0,
    );
  }

  bool get hasData =>
      totalLandVisit +
          totalDraftEidVisit +
          totalDraftVisitsAll +
          totalDraftJummaVisit +
          totalDraftRegularVisit +
          totalDraftOndemandVisit >
      0;
}


