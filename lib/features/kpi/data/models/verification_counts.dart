class VerificationCounts {
  final int employeeId;
  final int userId;
  final int classificationId;
  final int parentId;
  final int mosqueVerificationRequest;
  final int draftVerificationMosque;
  final int supervisorStageVerificationMosque;
  final int managementStageVerificationMosque;
  final int doneVerificationMosques;
  final int rejectedVerificationMosques;
  final int unverifiedMosques;
  final int totalAssignedMosques;
  final double verifiedPctDistinctMosques;

  VerificationCounts({
    required this.employeeId,
    required this.userId,
    required this.classificationId,
    required this.parentId,
    required this.mosqueVerificationRequest,
    required this.draftVerificationMosque,
    required this.supervisorStageVerificationMosque,
    required this.managementStageVerificationMosque,
    required this.doneVerificationMosques,
    required this.rejectedVerificationMosques,
    required this.unverifiedMosques,
    required this.totalAssignedMosques,
    required this.verifiedPctDistinctMosques,
  });

  factory VerificationCounts.fromJson(Map<String, dynamic> json) {
    return VerificationCounts(
      employeeId: json['employee_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      classificationId: json['classification_id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      mosqueVerificationRequest: json['mosque_verification_request'] ?? 0,
      draftVerificationMosque: json['draft_verification_mosque'] ?? 0,
      supervisorStageVerificationMosque: json['supervisor_stage_verification_mosque'] ?? 0,
      managementStageVerificationMosque: json['management_stage_verification_mosque'] ?? 0,
      doneVerificationMosques: json['done_verification_mosques'] ?? 0,
      rejectedVerificationMosques: json['rejected_verification_mosques'] ?? 0,
      unverifiedMosques: json['unverified_mosques'] ?? 0,
      totalAssignedMosques: json['total_assigned_mosques'] ?? 0,
      verifiedPctDistinctMosques: (json['verified_pct_distinct_mosques'] ?? 0.0).toDouble(),
    );
  }

  // Check if the data object has actual data
  bool get hasData => mosqueVerificationRequest > 0;

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'user_id': userId,
      'classification_id': classificationId,
      'parent_id': parentId,
      'mosque_verification_request': mosqueVerificationRequest,
      'draft_verification_mosque': draftVerificationMosque,
      'supervisor_stage_verification_mosque': supervisorStageVerificationMosque,
      'management_stage_verification_mosque': managementStageVerificationMosque,
      'done_verification_mosques': doneVerificationMosques,
      'rejected_verification_mosques': rejectedVerificationMosques,
      'unverified_mosques': unverifiedMosques,
      'total_assigned_mosques': totalAssignedMosques,
      'verified_pct_distinct_mosques': verifiedPctDistinctMosques,
    };
  }
}
