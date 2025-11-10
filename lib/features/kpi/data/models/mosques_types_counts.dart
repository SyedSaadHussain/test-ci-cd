class MosquesTypesCounts {
  final int employeeId;
  final int userId;
  final int classificationId;
  final int parentId;
  final int jamee;
  final int regular;
  final int eid;

  MosquesTypesCounts({
    required this.employeeId,
    required this.userId,
    required this.classificationId,
    required this.parentId,
    required this.jamee,
    required this.regular,
    required this.eid,
  });

  factory MosquesTypesCounts.fromJson(Map<String, dynamic> json) {
    return MosquesTypesCounts(
      employeeId: json['employee_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      classificationId: json['classification_id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      jamee: json['jamee'] ?? 0,
      regular: json['regular'] ?? 0,
      eid: json['eid'] ?? 0,
    );
  }

  bool get hasData => jamee > 0 || regular > 0 || eid > 0;

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'user_id': userId,
      'classification_id': classificationId,
      'parent_id': parentId,
      'jamee': jamee,
      'regular': regular,
      'eid': eid,
    };
  }
}


