class DailyKpi {
  final String workday;
  final int dayInprogress;
  final int dayDone;
  final int dayTotal;
  final double dailyTarget;
  final double dailyProgressPct;
  final int cumActual;
  final double cumExpected;
  final double mtdProgressPct;
  final double varianceVsPlan;

  const DailyKpi({
    required this.workday,
    required this.dayInprogress,
    required this.dayDone,
    required this.dayTotal,
    required this.dailyTarget,
    required this.dailyProgressPct,
    required this.cumActual,
    required this.cumExpected,
    required this.mtdProgressPct,
    required this.varianceVsPlan,
  });

  factory DailyKpi.fromJson(Map<String, dynamic> json) {
    return DailyKpi(
      workday: json['workday'] ?? '',
      dayInprogress: json['day_inprogress'] ?? 0,
      dayDone: json['day_done'] ?? 0,
      dayTotal: json['day_total'] ?? 0,
      dailyTarget: (json['daily_target'] ?? 0.0).toDouble(),
      dailyProgressPct: (json['daily_progress_pct'] ?? 0.0).toDouble(),
      cumActual: json['cum_actual'] ?? 0,
      cumExpected: (json['cum_expected'] ?? 0.0).toDouble(),
      mtdProgressPct: (json['mtd_progress_pct'] ?? 0.0).toDouble(),
      varianceVsPlan: (json['variance_vs_plan'] ?? 0.0).toDouble(),
    );
  }

  // Extract day number from workday date (e.g., "2025-10-02" -> 2)
  int get dayNumber {
    try {
      final date = DateTime.parse(workday);
      return date.day;
    } catch (e) {
      return 0;
    }
  }
}

class RegularVisitStats {
  final int employeeId;
  final int userId;
  final int classificationId;
  final int parentId;
  final int totalDraftVisit;
  final int totalLowDraftVisit;
  final int totalMediumDraftVisit;
  final int totalHighDraftVisit;
  final int thisMonthInprogressVisit;
  final int thisMonthDoneVisit;
  final int thisMonthTotalPerformed;
  final double thisMonthProgressPct;
  final double pctHighDraft;
  final double pctMediumDraft;
  final double pctLowDraft;
  final List<DailyKpi> dailyKpis;

  const RegularVisitStats({
    required this.employeeId,
    required this.userId,
    required this.classificationId,
    required this.parentId,
    required this.totalDraftVisit,
    required this.totalLowDraftVisit,
    required this.totalMediumDraftVisit,
    required this.totalHighDraftVisit,
    required this.thisMonthInprogressVisit,
    required this.thisMonthDoneVisit,
    required this.thisMonthTotalPerformed,
    required this.thisMonthProgressPct,
    required this.pctHighDraft,
    required this.pctMediumDraft,
    required this.pctLowDraft,
    this.dailyKpis = const [],
  });

  factory RegularVisitStats.fromJson(Map<String, dynamic> json) {
    List<DailyKpi> dailyKpisList = [];
    if (json['daily_kpis'] != null && json['daily_kpis'] is List) {
      dailyKpisList = (json['daily_kpis'] as List)
          .map((item) => DailyKpi.fromJson(item))
          .toList();
    }

    return RegularVisitStats(
      employeeId: json['employee_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      classificationId: json['classification_id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      totalDraftVisit: json['total_draft_visit'] ?? 0,
      totalLowDraftVisit: json['total_low_draft_visit'] ?? 0,
      totalMediumDraftVisit: json['total_medium_draft_visit'] ?? 0,
      totalHighDraftVisit: json['total_high_draft_visit'] ?? 0,
      thisMonthInprogressVisit: json['this_month_inprogress_visit'] ?? 0,
      thisMonthDoneVisit: json['this_month_done_visit'] ?? 0,
      thisMonthTotalPerformed: json['this_month_total_performed'] ?? 0,
      thisMonthProgressPct: (json['this_month_progress_pct'] ?? 0.0).toDouble(),
      pctHighDraft: (json['pct_high_draft'] ?? 0.0).toDouble(),
      pctMediumDraft: (json['pct_medium_draft'] ?? 0.0).toDouble(),
      pctLowDraft: (json['pct_low_draft'] ?? 0.0).toDouble(),
      dailyKpis: dailyKpisList,
    );
  }

  bool get hasData =>
      totalDraftVisit +
          totalLowDraftVisit +
          totalMediumDraftVisit +
          totalHighDraftVisit >
      0;
}

